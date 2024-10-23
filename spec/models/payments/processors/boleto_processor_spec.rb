# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Payments::Processors::BoletoProcessor, type: :model do
  let(:customer) { Fabricate(:customer, payment_method: 'boleto') }
  let(:invoice) { Fabricate(:invoice, customer:) }
  let(:processor) { customer.payment_processor }
  let(:adapter) { PagarMe::Boleto }
  let(:mailer) { PaymentMailer }
  let(:url) { "foobar.com/boleto" }
  let(:params) do
    {
      card_number: "1000000000001234",
      card_expiration_date: '02/27',
      card_cvv: '765',
      card_holder_name: 'Frodo'
    }
  end
  let(:api_response) { { url: url } }

  before do
    allow(Payments).to receive(:for).with('boleto').and_return(described_class)
    allow(adapter).to receive(:create).and_return(api_response)
    allow(mailer).to receive(:with).and_call_original
  end

  describe 'subscribe' do
    it 'returns nil' do
      expect(processor.subscribe(params)).to be_nil
    end
  end

  describe 'charge' do
    it 'calls the adapter with right arguments' do
      processor.charge(invoice)

      expect(adapter).to have_received(:create).with(
        amount: 50_000,
        payment_method: invoice.payment_method,
        customer: {
          email: customer.email
        }
      )
    end

    context 'when succesfuly charges' do
      it 'calls the mailer with right arguments' do
        processor.charge(invoice)

        expect(mailer).to have_received(:with).with(customer:, url:)
      end
    end

    context 'when there has an error' do
      let(:error) { PagarMe::Boleto::ConnectionError }
      let(:expected_error) { Payments::Processors::BoletoProcessor::ConnectionError }
      let(:message) { "Connection error. Try again later." }

      before do
        allow(adapter).to receive(:create).and_raise(error)
      end

      it 'raises and logs the correct error and message' do
        allow(Rails.logger).to receive(:error)

        expect { processor.charge(invoice) }.to raise_error expected_error, message
        expect(Rails.logger).to have_received(:error).once
      end
    end
    end
end

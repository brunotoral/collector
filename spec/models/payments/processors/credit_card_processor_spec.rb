# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Payments::Processors::CreditCardProcessor, type: :model do
  let(:customer) { Fabricate(:customer, payment_method: 'credit_card') }
  let(:invoice) { Fabricate(:invoice, customer: customer) }
  let(:processor) { customer.payment_processor }
  let(:adapter) { PagarMe::Card }
  let(:mailer) { PaymentMailer }
  let(:params) do
    {
      card_number: "1000000000001234",
      card_expiration_date: '02/27',
      card_cvv: '765',
      card_holder_name: 'Frodo'
    }
  end
  let(:api_response) do
    {
      token: SecureRandom.urlsafe_base64,
      brand: "Mastercard",
      last_digits: "1234",
      expiration_date: "02/27"
    }
  end

  before do
    allow(Payments).to receive(:for).with('credit_card').and_return(described_class)
    allow(adapter).to receive(:create).and_return(api_response)
    allow(mailer).to receive(:credit_card_email).and_call_original
  end

  describe 'subscribe' do
    it 'calls the adapter with right arguments' do
      processor.subscribe(params)

      expect(adapter).to have_received(:create).with(
        number: params[:card_number],
        expiration_date: params[:card_expiration_date],
        cvv: params[:card_cvv],
        holder_name: params[:card_holder_name],
        customer: customer.id
      )
    end

    it "creates a credit card" do
      expect { processor.subscribe(params) }.to change(CreditCard, :count).by(1)
    end
  end

  describe 'charge' do
    let(:credit_card) { double("CreditCard", toke: '1231123') }

    before do
      allow(Rails.logger).to receive(:error)
      allow(customer).to receive(:credit_card).and_return(credit_card)
      allow(credit_card).to receive(:token)
    end

    context 'when succesfuly charges' do
      it 'calls the mailer with right arguments' do
        allow(adapter).to receive(:charge).and_return(true)

        processor.charge(invoice)

        expect(mailer).to have_received(:credit_card_email).with(customer)
      end
    end

    context 'when there has an error' do
      let(:error) { PagarMe::Card::ConnectionError }
      let(:expected_error) { Payments::Processors::CreditCardProcessor::ConnectionError }
      let(:message) { "Connection error. Try again later." }

      it 'raises and logs the correct error and message' do
        allow(adapter).to receive(:charge).and_raise(error)

        expect { processor.charge(invoice) }.to raise_error expected_error, message
        expect(Rails.logger).to have_received(:error).once
      end
    end
    end
end

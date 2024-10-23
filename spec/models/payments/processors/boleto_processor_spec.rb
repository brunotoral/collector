# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Payments::Processors::BoletoProcessor, type: :model do
  let(:customer) { Fabricate(:customer, payment_method: 'boleto') }
  let(:invoice) { Fabricate(:invoice, customer: customer) }
  let(:processor) { customer.payment_processor }
  let(:params) do
    {
      foo: 'bar',
      bar: 'foo'
}
  end
  let(:api_response) { { url: 'foobar.com/boleto' } }

  before do
    allow(Payments).to receive(:for).with('boleto').and_return(described_class)
    allow(PagarMeBoleto).to receive(:create).and_return(api_response)
  end

  describe 'subscribe' do
    it 'returns nil' do
      expect(processor.subscribe(params)).to be_nil
    end
  end

  describe 'charge' do
    context 'when succesfuly charges' do
      it 'calls the adapter with right arguments' do
        processor.charge(invoice)

        expect(PagarMeBoleto).to have_received(:create).with(
          amount: 50_000,
          payment_method: invoice.payment_method,
          customer: {
            email: customer.email
          }
        )
      end
    end
  end
end

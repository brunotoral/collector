require 'rails_helper'

RSpec.describe SubscribePaymentJob, type: :job do
  include ActiveJob::TestHelper

  let!(:customer) do
   # Customer.create(
   #   due_day: Faker::Number.between(from: 1, to: 31),
   #   email: Faker::Internet.email,
   #   name: Faker::Movies::LordOfTheRings.character,
   #   payment_method: 'credit_card'
   # )
    Fabricate.create(:customer, payment_method: 'credit_card')
  end
  let(:credit_card_params) do
    {
      card_number: "1000000000001234",
      card_expiration_date: '02/27',
      card_cvv: '765',
      card_holder_name: 'Frodo'
    }
  end
  let(:processor) { customer.payment_processor }
  let(:adapter) { PagarMe::Card }
  let(:api_response) do
    {
      token: SecureRandom.urlsafe_base64,
      brand: "Mastercard",
      last_digits: "1234",
      expiration_date: "02/27"
    }
  end
  subject(:job) { described_class.perform_later(customer, credit_card_params) }

  context 'when parames are present' do
    let(:result) { true }
    let(:credit_card_processor_instance) { instance_double(Payments::Processors::CreditCardProcessor) }
    let(:credit_card_processor_class_double) do
      class_double(Payments::Processors::CreditCardProcessor).as_stubbed_const
    end

    before do
      allow(Payments).to receive(:for).with('credit_card').and_return(credit_card_processor_class_double)
      allow(credit_card_processor_class_double).to receive(:new).with(customer).and_return(credit_card_processor_instance)
      allow(customer).to receive(:payment_processor).and_return(credit_card_processor_instance)
      allow(credit_card_processor_instance).to receive(:subscribe).with(credit_card_params)
      allow(adapter).to receive(:create).and_call_original
      allow(customer).to receive(:create_next_invoice!)
    end

    it 'subscribe the customer' do
      perform_enqueued_jobs do
        job
      end
      expect(credit_card_processor_instance).to have_received(:subscribe).with(credit_card_params)
    end
  end

  after do
    clear_enqueued_jobs
    clear_performed_jobs
  end
end

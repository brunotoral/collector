# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Payments::Processors::BaseProcessor do
  let(:customer) { Fabricate(:customer, payment_method: 'credit_card') }
  let(:invoice) { Fabricate(:invoice, customer: customer) }

  subject { described_class.new(customer) }

  describe '#initialize' do
    it 'sets the customer' do
      expect(subject.instance_eval { customer }).to eq(customer)
    end
  end

  describe '#charge' do
    it 'returns NotImplementedError' do
      expect { subject.charge(invoice) }.to raise_error NotImplementedError,  "Must implement this method."
    end
  end
end

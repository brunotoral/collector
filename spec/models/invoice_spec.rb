# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Invoice, type: :model do
  let!(:customer) { Fabricate(:customer) }
  subject(:invoice) { Fabricate(:invoice, status: :completed) }

  describe 'associations' do
    it { is_expected.to belong_to :customer }
  end

  describe 'delegations' do
    it { is_expected.to delegate_method(:payment_processor).to(:customer) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of :payment_method }
    it { is_expected.to validate_presence_of :due_date }
    it { is_expected.to validate_presence_of :status }
  end

  describe 'enums' do
    it { is_expected.to define_enum_for(:status).with_values(%i[pending failed completed]) }
  end

  describe '#incomplete?' do
    let(:invoice) { Fabricate(:invoice, status:) }

    context 'when status is failed' do
      let(:status) { :failed }

      it { expect(invoice).to be_incomplete }
    end

    context 'when status is pending' do
      let(:status) { :pending }

      it { expect(invoice).to be_incomplete }
    end

    context 'when status is completed' do
      let(:status) { :completed }

      it { expect(invoice).not_to be_incomplete }
    end
  end

  it 'calculates the dua date correctly' do
    today = Date.new(2024, 01, 15)
    expected_date = Date.new(2024, 02, 29)

    allow(Date).to receive(:today).and_return today

    new_customer = Fabricate(:customer, due_day: 31)
    new_invoice = Fabricate(:invoice, customer: new_customer)

    expect(new_invoice).to have_attributes due_date: expected_date
  end

  describe '#unique_invoice_per_month' do
    context 'when there has an invoice pending or completed for the next month' do
      let!(:invoice) { Fabricate(:invoice, customer:, status: [ :pending, :completed ].sample) }

      it 'raises and error' do
        expect { customer.create_next_invoice! }.to raise_error ActiveRecord::RecordInvalid,
  "Validation failed: There is already a completed or pending invoice for this customer this month."
      end
    end
  end
end

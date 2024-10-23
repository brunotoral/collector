# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Customer, type: :model do
  it { is_expected.to accept_nested_attributes_for :address }

  describe 'associations' do
    it { is_expected.to have_one(:address).dependent(:destroy) }
    it { is_expected.to have_many(:invoices).dependent(:destroy) }
    it { is_expected.to have_one(:credit_card).dependent(:destroy) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of :name }
    it { is_expected.to validate_presence_of :email }
    it { is_expected.to validate_presence_of :due_day }
    it { is_expected.to validate_numericality_of(:due_day).is_in 1..31 }
  end

  describe '.create_next_invoice!' do
    let(:customer) { Fabricate(:customer, payment_method: 'test_method') }
    let(:next_month) { Date.today.next_month.month }
    let(:last_invoice) { customer.invoices.last }

    context 'when customer does not have an invoice' do
      it 'create the first invoice' do
        expect { customer.create_next_invoice! }.to change(customer.invoices, :count).by(1)
      end

      it 'creates an invoice with the due_date set to next month' do
        customer.create_next_invoice!

        expect(last_invoice.due_date.month).to eq next_month
      end

      it 'creates an invoice with pending status' do
        customer.create_next_invoice!

        expect(last_invoice).to be_pending
      end
    end

    context 'when customer already has an invoice' do
      let!(:failed_invoice) do
        Fabricate(:invoice, customer:, status: :failed)
      end

      it 'create the next invoice' do
        expect { customer.create_next_invoice! }.to change(customer.invoices, :count).by(1)
      end

      it 'creates an invoice with the due_date set to next month' do
        customer.create_next_invoice!

        expect(last_invoice.due_date.month).to eq next_month
      end

      it 'creates an invoice with pending status' do
        customer.create_next_invoice!

        expect(last_invoice).to be_pending
      end
    end
  end
end

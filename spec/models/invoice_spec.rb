# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Invoice, type: :model do
  let!(:customer) { Fabricate(:customer, due_day: 31) }
  subject(:invoice) { Fabricate(:invoice, customer:) }

  describe 'associations' do
    it { is_expected.to belong_to :customer }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of :payment_method }
    it { is_expected.to validate_presence_of :due_date }
    it { is_expected.to validate_presence_of :status }
  end

  describe 'enums' do
    it { is_expected.to define_enum_for(:status).with_values(%i[pending failed completed]) }
  end

  it 'calculates the dua date correctly' do
    today = Date.new(2024,01, 15)
    expected_date = Date.new(2024, 02, 29)
    allow(Date).to receive(:today).and_return today

    expect(invoice).to have_attributes due_date: expected_date
  end
end

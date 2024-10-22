# frozen_string_literal: true

class Customer < ApplicationRecord
  has_one :address, dependent: :destroy
  has_one :credit_card, dependent: :destroy
  has_many :invoices, dependent: :destroy

  validates :name, :payment_method, presence: true
  validates :due_day, numericality: { in: 1..31 }, presence: true

  accepts_nested_attributes_for :address

  def create_next_invoice!
    invoices.create!(
      payment_method:,
      status: :pending
    )
  end

  def has_pending_or_completed_invoice_for_next_month?
    invoices.where(
      status: [ :completed, :pending ],
      due_date: next_month.beginning_of_month..next_month.end_of_month
    ).exists?
  end

  def payment_processor
    processor = Payments.for payment_method

    processor.new self
  end

  private

  def next_month
    Date.today.next_month
  end
end

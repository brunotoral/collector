# frozen_string_literal: true

class Invoice < ApplicationRecord
  belongs_to :customer

  validates :payment_method, :due_date, :status, presence: true
  validate :unique_invoice_per_month, on: :create

  enum :status, %i[pending failed completed]

  before_validation :calcule_due_date, on: :create

  delegate :payment_processor, to: :customer

  private

  def calcule_due_date
    last_day_of_next_month = next_month.end_of_month.day
    due_day = [ customer.due_day, last_day_of_next_month ].min

    self.due_date = Date.new(next_month.year, next_month.month, due_day)
  end

  def unique_invoice_per_month
    if customer.has_pending_or_completed_invoice_for_next_month?
      errors.add(
        :base,
        "There is already a completed or pending invoice for this customer this month."
      )
    end
  end

  def next_month
    Date.today.next_month
  end
end

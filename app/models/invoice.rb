# frozen_string_literal: true

class Invoice < ApplicationRecord
  belongs_to :customer

  validates :payment_method, :due_date, :status, presence: true

  enum :status, %i[pending failed completed]

  before_validation :calcule_due_date, on: :create

  private

  def calcule_due_date
    today = Date.today
    next_month = today.next_month
    last_day_of_next_month = next_month.end_of_month.day
    due_day = [customer.due_day, last_day_of_next_month].min

    self.due_date = Date.new(next_month.year, next_month.month, due_day)
  end
end

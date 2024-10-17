# frozen_string_literal: true

class Customer < ApplicationRecord
  has_one :address, dependent: :destroy
  has_many :invoices, dependent: :destroy

  validates :name, :payment_method, presence: true
  validates :due_day, numericality: { in: 1..31 }, presence: true


  def create_next_invoice!
    self.invoices.create!(
      payment_method:,
      status: :pending
    )
  end
end

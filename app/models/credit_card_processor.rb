# frozen_string_literal: true

class CreditCardProcessor
  include Payments

  attr_reader :customer

  def initialize(customer)
    @customer = customer
  end
end

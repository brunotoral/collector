# frozen_string_literal: true

class PixProcessor
  include Payments

  attr_reader :customer

  def initialize(customer)
    @customer = customer
  end
end

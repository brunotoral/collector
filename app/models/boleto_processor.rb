# frozen_string_literal: true

class BoletoProcessor
  include Payments

  attr_reader :customer

  def initialize(customer)
    @customer = customer
  end

  def process
   customer.name
    #Stripe::CreditCard.new(
     # uid: customer.payment_info
    #).charge
  end
end

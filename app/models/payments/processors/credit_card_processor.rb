# frozen_string_literal: true

module Payments
  module Processors
    class CreditCardProcessor
      include Payments::Processor

      def initialize(customer)
        @customer = customer
      end

      def subscribe(opts)
        transaction = subscriibe_card
        customer.create_credit_card! transaction
      end

      def charge(invoice, amount = 50)
        PagarMeCard.charge(
          amount:,
          payment_method: invoice.payment_method,
          card_id: customer.credit_card.token
        )
      end

      private

      def subscribe_card
        PagarMeCard.create(
          number: params[:card_number],
          expiration_date: params[:card_expiration_date],
          cvv: params[:card_cvv],
          holder_name: params[:card_holder_name],
          customer: customer.id
        )
      end

      attr_reader :customer
    end
  end
end

class PagarMeCard
  class ConectionError < StandardError; end
  class NoFundError < StandardError; end

  def self.create(**opts)
    {
      token: SecureRandom.urlsafe_base64,
      brand: %w[Visa Mastercard AmericanExpress Discover].sample,
      last_digits: opts[:number][-4..-1],
      expiration_date: opts[:expiration_date]
    }
  end

  def self.charge(**opts)
    bar = [ 1, 2, 3, 4, 5, 6 ].sample
    if [ 1, 2 ].include? bar
      raise ConectionError, "Conection Error"
    elsif [ 3, 4 ].include? bar
      reise NoFundError, "Does not have money"
    else
      true
    end
  end
end

# frozen_string_literal: true

module Payments
  module Processors
    class CreditCardProcessor < BaseProcessor
      def subscribe(options = {})
        transaction = subscribe_card(**options)

        customer.create_credit_card! transaction
      end

      private

      def create_transaction!(invoice, amount)
        PagarMe::Card.charge(
          amount:,
          payment_method: invoice.payment_method,
          card_id: customer.credit_card.token
        )
      end

      def subscribe_card(params = {})
        PagarMe::Card.create(
          number: params[:card_number],
          expiration_date: params[:card_expiration_date],
          cvv: params[:card_cvv],
          holder_name: params[:card_holder_name],
          customer: customer.id
        )
      end
    end
  end
end

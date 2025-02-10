# frozen_string_literal: true

module Payments
  module Processors
    class BoletoProcessor < BaseProcessor
      def subscribe(options = {})
        nil
      end

      private

      def create_transaction!(invoice, amount)
        PagarMe::Boleto.create(
          amount:,
          payment_method: invoice.payment_method,
          customer: {
            email: customer.email
          }
        )
      end
    end
  end
end

# frozen_string_literal: true

module Payments
  module Processors
    class PixProcessor < BaseProcessor
      def subscribe(options = {})
        nil
      end

      private

      def create_transaction!(invoice, amount)
        PagarMe::Pix.create(
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

# frozen_string_literal: true

class StripeBoleto
end
module Payments
  module Processors
    class BoletoProcessor
      include Payments::Processor

      def initialize(invoice, adapter = StripeBoleto.new)
        @invoice = invoice
        @adapter = adapter
        @customer = invoice.customer
      end

      def process
        customer.name
        # Stripe::CreditCard.new(
        # uid: customer.payment_info
        # ).charge
      end

      private

      attr_reader :adapter, :invoice, :customer
    end
  end
end

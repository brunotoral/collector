# frozen_string_literal: true

module Payments
  module Processors
    class CreditCardProcessor
      include Payments

      def initialize(invoice, adapter = StripeBoleto.new)
        @invoice = invoice
        @adapter = adapter
        @customer = invoice.customer
      end

      private

      attr_reader :adapter, :invoice, :customer
    end
  end
end

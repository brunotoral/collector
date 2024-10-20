# frozen_string_literal: true

module Payments
  module Processors
    class PixProcessor
      include Payments::Processor

      def initialize(invoice, adapter = StripePix.new)
        @invoice = invoice
        @adapter = adapter
        @customer = invoice.customer
      end

      private

      attr_reader :adapter, :invoice, :customer
    end
  end
end

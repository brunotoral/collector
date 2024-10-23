# frozen_string_literal: true

module Payments
  module Processors
    class PixProcessor
      include Payments::Processor

      def initialize(customer)
        @customer = customer
      end

      def subscribe(options = {})
        nil
      end

      def charge(invoice, amount = 50_000)
        transaction = PagarMePix.create(
          amount:,
          payment_method: invoice.payment_method,
          customer: {
            email: customer.email
          }
        )

        PixMailer.perform_later customer, transaction[:url]
      end

      private

      attr_reader :customer
    end
  end
end

class PagarMePix
  class ConectionError < StandardError; end

  def self.create(**opts)
    bar = [ 1, 2, 3, 4, 5, 6 ].sample
    if bar.even?
      raise ConectionError, "Conection Error"
    else
      {
        url: "http://pixurl.com.io"
      }
    end
  end
end

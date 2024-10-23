# frozen_string_literal: true

module Payments
  module Processors
    class BoletoProcessor
      include Payments::Processor

      class ConnectionError < StandardError; end

      def initialize(customer)
        @customer = customer
      end

      def subscribe(options = {})
        nil
      end

      def charge(invoice, amount = 50_000)
        transaction = create_transaction!(invoice, amount)

        send_notification(customer, transaction[:url])
      rescue StandardError => e
        log_and_raise_error e
      end

      private

      attr_reader :customer

      def send_notification(customer, url)
        PaymentMailer.with(
          customer:,
          url:,
        ).boleto_email.deliver_later
      end

      def create_transaction!(invoice, amount)
        PagarMe::Boleto.create(
          amount:,
          payment_method: invoice.payment_method,
          customer: {
            email: customer.email
          }
        )
      end

      def log_and_raise_error(error)
        case error
        when PagarMe::Boleto::ConnectionError
          log_error(error)
          raise ConnectionError, "Connection error. Try again later."
        else
          log_error(error)
          raise error
        end
      end

      def log_error(error)
        Rails.logger.error "#{self}: Error: #{error.message} fo customer: #{customer.email}"
      end
    end
  end
end

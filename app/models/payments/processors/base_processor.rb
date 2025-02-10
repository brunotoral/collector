# frozen_string_literal: true

module Payments
  module Processors
    class BaseProcessor
      include Payments::Processor
      include Payments::Errors

      CONNECTION_ERRORS = [
        PagarMe::Card::ConnectionError,
        PagarMe::Pix::ConnectionError,
        PagarMe::Boleto::ConnectionError
      ].freeze

      def initialize(customer)
        @customer = customer
      end

      def charge(invoice, amount = 50_000)
        transaction = create_transaction!(invoice, amount)

        send_notification(customer, transaction.try(:[], :url))
      rescue StandardError => e
        log_and_raise_error e
      end

      private

      attr_reader :customer

      def create_transaction!(invoice, amount)
        raise NotImplementedError, "Must implement this method."
      end

      def mailer_action
        "#{extracted_class_name.underscore}_email"
      end

      def extracted_class_name
        self.class.to_s.gsub("Payments::Processors::", "").gsub("Processor", "")
      end

      def send_notification(*opts)
        PaymentMailer.send(mailer_action, *opts.compact).deliver_later
      end

      def log_and_raise_error(error)
        case error
        when *CONNECTION_ERRORS
         log_error(error)
         raise ConnectionError.new
        when PagarMe::Card::NoFundsError
          log_error(error)
          raise NoFundsError.new
        else
          log_error(error)
          raise error
        end
      end

      def log_error(error)
        Rails.logger.error "#{self.class}: Error: #{error.message} fo customer: #{customer.email}"
      end
    end
  end
end

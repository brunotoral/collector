# frozen_string_literal: true

module Payments
  module Processors
    class CreditCardProcessor
      include Payments::Processor

      class ConnectionError < StandardError; end
      class NoFundsError < StandardError; end

      def initialize(customer)
        @customer = customer
      end

      def subscribe(options = {})
        transaction = subscribe_card(**options.to_h)

        customer.create_credit_card! transaction
      end

      def charge(invoice, amount = 50_000)
        create_transaction!(invoice, amount)

        send_notification(customer)
      rescue StandardError => e
        log_and_raise_error e
      end

      private

      attr_reader :customer

      def create_transaction!(invoice, amount)
        PagarMe::Card.charge(
          amount:,
          payment_method: invoice.payment_method,
          card_id: customer.credit_card.token
        )
      end

      def send_notification(customer)
        PaymentMailer.credit_card_email(customer).deliver_later
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

      def log_and_raise_error(error)
        case error
        when PagarMe::Card::ConnectionError
          log_error(error)
          raise ConnectionError, "Connection error. Try again later."
        when PagarMe::Card::NoFundsError
          log_error(error)
          raise NoFundsError, "No funds."
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

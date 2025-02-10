# frozen_string_literal: true

module Payments
  module Errors
    class ConnectionError < StandardError
      ERRORS = [
        PagarMe::Card::ConnectionError,
        PagarMe::Pix::ConnectionError,
        PagarMe::Boleto::ConnectionError
      ].freeze

      def initialize(msg = "Connection error. Try again later.")
        super
      end
    end
  end
end

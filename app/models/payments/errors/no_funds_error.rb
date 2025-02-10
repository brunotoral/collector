
# frozen_string_literal: true

module Payments
  module Errors
    class NoFundsError < StandardError
      ERRORS = [
        PagarMe::Card::NoFundsError
      ].freeze

      def initialize(msg = "No funds.")
        super
      end
    end
  end
end

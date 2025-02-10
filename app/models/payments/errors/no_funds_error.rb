
# frozen_string_literal: true

module Payments
  module Errors
    class NoFundsError < StandardError
      def initialize(msg = "No funds.")
        super
      end
    end
  end
end

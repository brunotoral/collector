# frozen_string_literal: true

module Payments
  module Errors
    class ConnectionError < StandardError
      def initialize(msg = "Connection error. Try again later.")
        super
      end
    end
  end
end

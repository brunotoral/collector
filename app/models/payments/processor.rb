# frozen_string_literal: true

module Payments
  module Processor
    def process
      raise NotImplementedError, "your processor should implement this method"
    end
  end
end

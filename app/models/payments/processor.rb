# frozen_string_literal: true

module Payments
  module Processor
    def charge(invoice, options = {})
      raise NotImplementedError, "your processor should implement this method"
    end

    def subscribe(default_adapter: nil, **options)
      raise NotImplementedError, "your processor should implement this method"
    end
  end
end

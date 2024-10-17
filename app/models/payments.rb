# frozen_string_literal: true

module Payments
  include ActiveSupport::Configurable

  class ProcessorNotFoundError < StandardError; end

  config_accessor :processors, default: {}

  def self.method_names
    config.processors.keys
  end

  def self.for(name)
    Payments.processors[name] || raise(ProcessorNotFoundError, "Processor #{name} is not registered")
  end

  def process
    raise NotImplementedError, "your processor should implement this method"
  end
end

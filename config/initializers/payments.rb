# frozen_string_literal: true

unless Rails.env.test?
  Rails.application.config.to_prepare do
    Payments.configure do |config|
      config.processors["boleto"] = Payments::Processors::BoletoProcessor
      config.processors["pix"] = Payments::Processors::PixProcessor
      config.processors["credit_card"] = Payments::Processors::CreditCardProcessor
    end
  end
end

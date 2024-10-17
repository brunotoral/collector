# frozen_string_literal: true

unless Rails.env.test?
  Rails.application.config.to_prepare do
    Payments.configure do |config|
      config.processors["boleto"] = BoletoProcessor
      config.processors["pix"] = PixProcessor
      config.processors["credit_card"] = CreditCardProcessor
    end
  end
end

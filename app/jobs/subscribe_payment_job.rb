class SubscribePaymentJob < ApplicationJob
  queue_as :default

  def perform(customer, params = {})
    customer.with_lock do
      discard! unless params.blank?

      customer.payment_processor.subscribe(params)
    end
  end
end

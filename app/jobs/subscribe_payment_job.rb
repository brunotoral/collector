# frozen_string_literal: true

class SubscribePaymentJob < ApplicationJob
  queue_as :default

  def perform(customer, params = {})
    customer.with_lock do
      discard! unless customer.present?
      customer.payment_processor.subscribe(params)
      customer.create_next_invoice!
    rescue => e
      Rails.logger.error "#{self} failed (JOB ID: #{job_id}): #{e.message} #{params}"
      puts "#{self} failed (JOB ID: #{job_id}): #{e.message} #{params}"
    end
  end
end

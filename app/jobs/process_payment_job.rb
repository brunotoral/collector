# frozen_string_literal: true

class ProcessPaymentJob < ApplicationJob
  queue_as :default

  # on rake
  # due_date = Date.today
  # invoices = Invoice.pending.where(due_date:).include(:customer)
  # invoices.each { |invoice| ProcessPaymentJob.perform_later invoice }
  #
  retry_on StandardError, wait: 30.seconds, attempts: 3 do |job, error|
    job.arguments[0].update!(
      status: :failed,
      comment: error.message
    )

    log_error(job.job_id, error.message)
  end

  discard_on NotImplementedError do |job, error|
    job.arguments[0].update!(
      status: :failed,
      comment: error.message
    )

    log_error(job.job_id, error.message)
  end

  def perform(invoice)
    invoice.with_lock do
      processor = Payments.for(invoice.payment_method)

      processor.new(invoice).process

      invoice.completed!
      Rails.logger.info invoice.status
      invoice.customer.create_next_invoice!
    end
  end

  def self.log_error(job_id, message)
    Rails.logger.error "#{self} failed (JOB ID: #{job_id}): #{message}"
  end
end

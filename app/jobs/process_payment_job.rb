# frozen_string_literal: true

class ProcessPaymentJob < ApplicationJob
  queue_as :default

  retry_on StandardError, wait: 30.seconds, attempts: 3 do |job, error|
    job.arguments[0].update!(
      status: :failed,
      comment: error.message
    )

    log_error(job.job_id, error.message)
  end

  discard_on NotImplementedError, Payments::ProcessorNotFoundError, ActiveRecord::RecordInvalid, Payments::Processors::CreditCardProcessor::NoFundsError do |job, error|
    job.arguments[0].update!(
      status: :failed,
      comment: error.message
    )

    log_error(job.job_id, error.message)
  end

  def perform(invoice)
    invoice.with_lock do
      processor = invoice.payment_processor

      processor.charge(invoice)

      invoice.completed!

      invoice.customer.create_next_invoice!

      log_info(invoice)
    end
  end

  def self.log_error(job_id, message)
    Rails.logger.error "#{self} failed (JOB ID: #{job_id}): #{message}"
  end

  def log_info(invoice)
    Rails.logger.info "#{self}: Invoice payment processed for customer #{invoice.customer.name}.\
      Payment method #{invoice.payment_method}"
  end
end

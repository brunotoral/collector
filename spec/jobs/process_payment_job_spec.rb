require 'rails_helper'

RSpec.describe ProcessPaymentJob, type: :job do
  include ActiveJob::TestHelper

  let(:invoice) { Fabricate(:invoice, status: :pending) }
  subject(:job) { described_class.perform_later(invoice) }

  before do
    allow(Rails.logger).to receive(:error)
  end

  context 'when StandardError is raised' do
    before do
      allow(Payments).to receive(:for).and_raise(StandardError)
    end

    it 'sets invoice status to failed' do
      perform_enqueued_jobs do
        job
      end

      expect(invoice.reload).to be_failed
    end

    it 'makes 3 retries' do
      assert_performed_jobs 3 do
        job
      end
    end
  end

  context 'when NotImplementedError or Payments::ProcessorNotFoundError or ActiveRecord::RecordInvalid is raised' do
    let(:error) do
      [
        NotImplementedError.new('error'),
        Payments::ProcessorNotFoundError.new('error'),
        ActiveRecord::RecordInvalid
      ].sample
    end

    before do
      allow(Payments).to receive(:for).and_raise(error)
    end

    it 'sets invoice status to failed' do
      perform_enqueued_jobs do
        job
      end

      expect(invoice.reload).to be_failed
    end

    it 'does not retries' do
      assert_performed_jobs 1 do
        job
      end
    end

    it 'logs the error info' do
      perform_enqueued_jobs do
        job
      end

      expect(Rails.logger).to have_received(:error).with(include(ProcessPaymentJob.to_s, job.job_id))
    end
  end

  context 'when there are no errors' do
    let(:processor) { double('Processor') }

    before do
      invoice.update!(due_date: Date.today)
      allow(Payments).to receive(:for).with('boleto').and_return(processor)
      allow(processor).to receive(:new).and_return(processor)
      allow(invoice).to receive(:payment_processor)
      allow(processor).to receive(:charge).with(invoice)
    end

    it 'sets invoice status to completed' do
      perform_enqueued_jobs do
        job
      end

      expect(invoice.reload).to be_completed
    end

    it 'creates the next invoice' do
      perform_enqueued_jobs do
        job
      end

      last_invoice = invoice.customer.invoices.last

      expect(last_invoice).to be_pending
    end
  end

  after do
    clear_enqueued_jobs
    clear_performed_jobs
  end
end

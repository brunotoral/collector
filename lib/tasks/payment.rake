namespace :payment do
  desc "Collect all payments due today"
  task collect: :environment do
    puts "#### Find invoices due today..."
    invoices = Invoice.pending.where(due_date: Date.today).includes(:customer)

    puts "#### Scheduling payment processing..."
    invoices.each { |invoice| ProcessPaymentJob.deliver_later(invoice) }

    puts "#### Task completed successfully."
  end
end

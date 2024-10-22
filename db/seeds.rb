# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
#

# Create a User
user = Fabricate(:user, email: 'admin@collector.com')

# Create two Customer to every registred Payment method

today = Date.today

Payment.method_names.each do |method|
  Fabricate(:customer, due_day: today.day, payment_method: method)
  Fabricate(:customer, payment_method: method)
end

# Credit Card criar
#
#

# Create invoice and update due_date to process the payment today
customers = Customer.where(due_day: today.day)

customers.each do |customer|
  customer.create_next_invoice!

  invoice = customer.invoices.last

  invoice.update!(due_date: today)
end

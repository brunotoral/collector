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
return if Rails.env.test?


puts "########## Creating User. email: admin@collecto.com password: 1q2w3e4r"

Fabricate(:user, email: 'admin@collector.com')

puts "########## User Created!"

today = Date.today

puts "########## Create two Customer to each registred Payment method"

Payments.method_names.each do |method|
  customer_one = Fabricate(:customer, due_day: today.day, payment_method: method)
  customer_two = Fabricate(:customer, payment_method: method)

  if method.eql? 'credit_card'
    puts "########## Creating Credit card."

    Fabricate(:credit_card, customer: customer_one)
    Fabricate(:credit_card, customer: customer_two)
  end
end

puts "########## Creating invoices"
today_customers = Customer.where(due_day: today.day)
not_today_customers = Customer.where.not(due_day: today.day)

create_and_update_invoice(today_customers, today)
create_and_update_invoice(not_today_customers)

def create_and_update_invoice(customer, date = nil)
  customers.each do |customer|
    customer.create_next_invoice!

    if date
      invoice = customer.invoices.last

      invoice.update!(due_date: date)
    end
  end
end

puts "########## Seed finished ##########"

# Preview all emails at http://localhost:3000/rails/mailers/payment

class PaymentPreview < ActionMailer::Preview
  def boleto_email
    customer =  Customer.first
    url =  "preview.url/boleto"

    PaymentMailer.boleto_email(customer, url)
  end

  def credit_card_email
    customer =  Customer.first

    PaymentMailer.credit_card_email(customer)
  end

  def pix_email
    customer =  Customer.first
    url =  "preview.url/pix"

    PaymentMailer.pix_email(customer, url)
  end
end

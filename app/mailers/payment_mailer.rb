# frozen_string_literal: true

class PaymentMailer < ApplicationMailer
  def boleto_email(customer, url)
    @customer = customer
    @url = url

    mail(to: @customer.email, subject: "Pay Your Invoice Now - Boleto")
  end

  def pix_email(customer, url)
    @customer = customer
    @url = url

    mail(to: @customer.email, subject: "Pay Your Invoice Now - Pix")
  end


  def credit_card_email(customer)
    @customer = customer

    mail(to: @customer.email, subject: "Payment credited - Credit Card")
  end
end

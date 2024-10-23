class PaymentMailer < ApplicationMailer
  def boleto_email
    @customer = params[:customer]
    @url = params[:url]

    mail(to: @customer.email, subject: "Pay Your Invoice Now - Boleto")
  end

  def pix_email
    @customer = params[:customer]
    @url = params[:url]

    mail(to: @customer.email, subject: "Pay Your Invoice Now - Pix")
  end


  def credit_card_email
    @customer = params[:customer]

    mail(to: @customer.email, subject: "Payment credited - Credit Card")
  end
end

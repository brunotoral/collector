require "rails_helper"

RSpec.describe PaymentMailer, type: :mailer do
  describe 'boleto_email' do
    let(:customer) { double(Customer, email: 'customer@example.com', name: "Bar") }
    let(:url) { 'https://boleto/123' }
    let(:mail) do
      described_class.with(
        customer: customer,
        url: url
      ).boleto_email.deliver_now
    end

    it 'renders the subject' do
      expect(mail.subject).to eq "Pay Your Invoice Now - Boleto"
    end

    it 'renders the receiver email' do
      expect(mail.to).to match_array customer.email
    end

    it 'assigns @url' do
      expect(mail.body.encoded).to match(url)
    end
  end

  describe 'pix_email' do
    let(:customer) { double(Customer, email: 'customer@example.com', name: "Bar") }
    let(:url) { 'https://pix/123' }
    let(:mail) do
      described_class.with(
        customer: customer,
        url: url
      ).pix_email.deliver_now
    end

    it 'renders the subject' do
      expect(mail.subject).to eq "Pay Your Invoice Now - Pix"
    end

    it 'renders the receiver email' do
      expect(mail.to).to match_array customer.email
    end

    it 'assigns @url' do
      expect(mail.body.encoded).to match(url)
    end
  end

  describe 'credit_card_email' do
    let(:customer) { double(Customer, email: 'customer@example.com', name: "Bar") }
    let(:url) { 'https://pix/123' }
    let(:mail) do
      described_class.with(
        customer: customer
      ).credit_card_email.deliver_now
    end

    it 'renders the subject' do
      expect(mail.subject).to eq "Payment credited - Credit Card"
    end

    it 'renders the receiver email' do
      expect(mail.to).to match_array customer.email
    end

    it 'assigns @url' do
      expect(mail.body.encoded).to match(customer.name)
    end
  end
end

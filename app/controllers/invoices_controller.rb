# frozen_string_literal: true

class InvoicesController < ApplicationController
  before_action :set_customer
  before_action :set_invoice, except: :index

  def index
    @invoices = @customer.invoices
  end

  def show
  end

  def edit
  end

  def update
    if @invoice.update(invoice_params)
      redirect_to customer_invoice_path(@customer, @invoice), notice: "Invoice was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def invoice_params
    params.require(:invoice).permit(:status, :payment_method, :comment)
  end

  def set_customer
    @customer = Customer.find params[:customer_id]
  end

  def set_invoice
    @invoice = @customer.invoices.find params[:id]
  end
end

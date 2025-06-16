# frozen_string_literal: true

class CustomersController < ApplicationController
  before_action :set_customer, only: %i[show edit update destroy]

  def index
    @customers = paginate(Customer.all)
  end

  def show
  end

  def new
    @customer = Customer.new
    @address = @customer.build_address
  end

  def edit
    @address = @customer.address
  end

  def create
    @customer = Customer.new(customer_params.except(:credit_card))

    if @customer.save
      SubscribePaymentJob.perform_later(@customer, customer_params[:credit_card])

      redirect_to @customer, notice: "Customer was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @customer.update(customer_params.except(:credit_card))
      redirect_to @customer, notice: "Customer was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @customer.destroy!

    redirect_to customers_path, status: :see_other, notice: "Customer was successfully destroyed."
  end

  private

  def set_customer
    @customer = Customer.find(params[:id])
  end

  def customer_params
    params.require(:customer).permit(
      :name,
      :email,
      :due_day,
      :payment_method,
      address_attributes:
      [
        :street,
        :zipcode,
        :district,
        :city,
        :state,
        :number,
        :supplement
      ],
      credit_card: [
        :card_number,
        :card_expiration_date,
        :card_cvv,
        :card_holder_name
      ]
    )
  end
end

# frozen_string_literal: true

class ReactController < ApplicationController
  skip_before_action :authenticate_user!
  skip_before_action :verify_authenticity_token

  def nav_bar
    respond_to do |format|
      format.json {
        render json: {
          "Customers" => "/react/customers" + root_path,
          "Today's reports" => "/react" + invoice_reports_path,
          "New customer" => "/react" + new_customer_path
        }
      }
    end
  end

  def address
    @address = Address.find_by customer_id: params[:customer_id]
    respond_to do |format|
      format.json { render json: @address.as_json(except: %i[id created_at updated_at]) }
    end
  end

  def foobar
    ActionCable.server.broadcast "notifications", { message: params[:foobar] }
  end

  def customers
    respond_to do |format|
      format.json { render json: api_paginate(Customer.all) }
    end
  end

  def invoice_reports
    respond_to do |format|
      format.json { render json: Invoice.all }
    end
  end

  def new_customer
    respond_to do |format|
      format.json {
        render json: {
          customer: Customer.new.as_json(except: %i[id created_at updated_at]),
          select_options: helpers.payment_methods_for_select
        }
      }
    end
  end

  def edit_customer
    respond_to do |format|
      @customer = Customer.find params[:id]
      format.json { render json: @customer.as_json(except: %i[id created_at updated_at]) }
    end
  end

  def update_customer
    respond_to do |format|
      @customer = Customer.find params[:id]

      if @customer.update(customer_params.except(:credit_card))
        format.json { render json: @customer.as_json(except: %i[id created_at updated_at]) }
      else
        format.json { render json: @customer.errors,  status: :unprocessable_entity }
      end
    end
  end

  def create_customer
    respond_to do |format|
      @customer = Customer.new(customer_params.except(:credit_card))

      if @customer.save
        @customer.payment_processor.subscribe(customer_params[:credit_card])
        @customer.create_next_invoice!

        format.json { render json: @customer, status: :created }
      else
        format.json { render json: @customer.errors,  status: :unprocessable_entity }
      end
    end
  end

  private

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

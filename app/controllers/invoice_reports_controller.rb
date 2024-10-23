# frozen_string_literal: true

class InvoiceReportsController < ApplicationController
  def index
    @invoices = filtered_invoices
  end

  private

  def filtered_invoices
    if %w[completed failed].include? params[:filter].to_s
      base_query.send(params[:filter])
    else
      base_query
    end
  end

  def base_query
    Invoice.not_pending.where(due_date: Date.today).includes(:customer)
  end
end

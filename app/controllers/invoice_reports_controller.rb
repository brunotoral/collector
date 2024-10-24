# frozen_string_literal: true

class InvoiceReportsController < ApplicationController
  def index
    @invoices = paginate(filtered_invoices)
  end

  private

  def filtered_invoices
    if %w[completed failed].include? params[:filter].to_s
      method = params[:filter] == "completed" ? :completed : :failed
      args = {}
      base_query.send(method, *args)
    else
      base_query
    end
  end

  def base_query
    Invoice.not_pending.where(due_date: Date.today).includes(:customer)
  end
end

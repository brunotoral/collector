# frozen_string_literal: true

module CustomersHelper
  def due_days_for_select
    (1..31).to_a
  end

  def payment_methods_for_select
    Payments.method_names.map { |m| [m.humanize, m] }
  end
end

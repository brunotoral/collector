# frozen_string_literal: true

module CustomersHelper
  def customer_due_day_for_select
    (1..31).to_a
  end
end

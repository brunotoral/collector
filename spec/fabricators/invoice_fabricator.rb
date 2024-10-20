# frozen_string_literal: true

Fabricator(:invoice) do
  customer { Fabricate(:customer) }
  payment_method "boleto"
  status { [ 0, 1, 2 ].sample }
  comment "Some comment"
end

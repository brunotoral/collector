# frozen_string_literal: true

Fabricator(:customer) do
  due_day { Faker::Number.between from: 1, to: 31 }
  email { Faker::Internet.email }
  name { Faker::Movies::LordOfTheRings.character }
  payment_method { [ 'boleto', 'credit_card', 'pix' ].sample }

  after_build do |customer|
    customer.address = Fabricate(:address, customer:)
    if customer.payment_method == 'credit_card'
      Fabricate(:credit_card, customer:)
    end
  end
end

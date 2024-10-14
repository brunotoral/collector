# frozen_string_literal: true

Fabricator(:customer) do
  due_day { Faker::Number.between from: 1, to: 31 }
  name { Faker::Movies::LordOfTheRings.character }
end

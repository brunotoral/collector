# frozen_string_literal: true

Fabricator(:address) do
  customer { Fabricate(:customer) }
  street { Faker::Address.street_name }
  number { Faker::Address.building_number }
  city { Faker::Address.city }
  state { Faker::Address.state }
  zipcode { Faker::Address.postcode }
  supplement { Faker::Address.secondary_address }
  district { Faker::Address.community }
end

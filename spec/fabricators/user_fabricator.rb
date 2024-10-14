# frozen_string_literal: true

Fabricator(:user) do
  email { Faker::Internet.email }
  password '1q2w3e4r'
end

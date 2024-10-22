Fabricator(:credit_card) do
  customer { Fabricate(:customer) }
  token { SecureRandom.urlsafe_base64 }
  last_digits { Faker::Number.number(digits: 4) }
  brand { %w[Visa Mastercard AmericanExpress Discover].sample }
  expiration_date { Faker::Date.between(from: Date.today, to: Date.today + 10.years).strftime('%m/%Y') }
end

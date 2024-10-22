class CreditCard < ApplicationRecord
  belongs_to :customer

  validates :token, :last_digits, :brand, :expiration_date, presence: true
end

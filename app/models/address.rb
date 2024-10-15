# frozen_string_literal: true

class Address < ApplicationRecord
  belongs_to :customer

  validates :street, :zipcode, :district, :city, :state, presence: true
end

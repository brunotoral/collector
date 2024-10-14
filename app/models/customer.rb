# frozen_string_literal: true

class Customer < ApplicationRecord
  validates :name, presence: true
  validates :due_day, numericality: { in: 1..31 }, presence: true
end

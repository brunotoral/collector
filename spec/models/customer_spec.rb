# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Customer, type: :model do
  describe 'validations' do
    it { is_expected.to validate_presence_of :name }
    it { is_expected.to validate_presence_of :due_day }
    it { is_expected.to validate_numericality_of(:due_day).is_in 1..31 }
  end
end

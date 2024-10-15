# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Address, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to :customer }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of :street }
    it { is_expected.to validate_presence_of :zipcode }
    it { is_expected.to validate_presence_of :district }
    it { is_expected.to validate_presence_of :city }
    it { is_expected.to validate_presence_of :state }
  end
end

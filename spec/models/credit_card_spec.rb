require 'rails_helper'

RSpec.describe CreditCard, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to :customer }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of :token }
    it { is_expected.to validate_presence_of :last_digits }
    it { is_expected.to validate_presence_of :brand }
    it { is_expected.to validate_presence_of :expiration_date }
  end
end

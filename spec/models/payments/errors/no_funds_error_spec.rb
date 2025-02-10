# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Payments::Errors::NoFundsError, type: :model do
  describe '#initialize' do
    it 'sets the defatul message' do
      expect(described_class.new.message).to eq "No funds."
    end
  end

  describe 'Errors constant' do
    it { expect(described_class).to have_constant(:ERRORS) }
    it { expect(described_class::ERRORS).to be_frozen }
  end
end

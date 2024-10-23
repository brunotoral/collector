# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FormHelper, type: :helper do
  describe '#user_facing_errors' do
    context 'when item has error' do
      let(:error) { double('Error', full_message: 'Error message') }
      let(:item) { double(Customer, errors: [ error ]) }

      it 'renders the full error message' do
        result = helper.user_facing_errors(item)
        expect(result).to match(/#{error.full_message}/)
      end
    end

    context 'when item has no errors' do
      let(:item) { double(Customer, errors: []) }

      it 'returns nil' do
        result = helper.user_facing_errors(item)
        expect(result).to be_nil
      end
    end
  end
end

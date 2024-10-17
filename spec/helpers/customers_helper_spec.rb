# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CustomersHelper, type: :helper do
  describe '#due_days_for_select' do
    it 'returns an array of numbers from 1 to 31' do
      expect(helper.due_days_for_select).to eq((1..31).to_a)
    end
  end

  describe '#payment_methods_for_select' do
    before do
      allow(Payments).to receive(:method_names).and_return(['credit_card', 'boleto'])
    end

    it 'returns an array of pairs with humanized and original method name' do
      expect(helper.payment_methods_for_select).to match(
        [
          ['Credit card', 'credit_card'],
          ['Boleto', 'boleto']
        ]
      )
    end
  end
end

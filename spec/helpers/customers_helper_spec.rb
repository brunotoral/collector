# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CustomersHelper, type: :helper do
  describe '#render_if_credit_card' do
    context 'when credit card is present' do
      let(:credit_card) { Fabricate(:credit_card) }

      it 'renders the credit card' do
        result = helper.render_if_credit_card(credit_card)
        expect(result).to match(/#{credit_card.last_digits}/)
      end
    end

    context 'when credit card is nil' do
      let(:credit_card) { nil }
      it 'returns nil' do
        result = helper.render_if_credit_card(credit_card)
        expect(result).to be_nil
      end
    end
  end

  describe '#due_days_for_select' do
    it 'returns an array of numbers from 1 to 31' do
      expect(helper.due_days_for_select).to eq((1..31).to_a)
    end
  end

  describe '#payment_methods_for_select' do
    before do
      allow(Payments).to receive(:method_names).and_return([ 'credit_card', 'boleto' ])
    end

    it 'returns an array of pairs with humanized and original method name' do
      expect(helper.payment_methods_for_select).to match(
        [
          [ 'Credit card', 'credit_card' ],
          [ 'Boleto', 'boleto' ]
        ]
      )
    end
  end
end

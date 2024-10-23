
# frozen_string_literal: true

require 'rails_helper'

RSpec.describe InvoicesController, type: :controller do
  include Devise::Test::ControllerHelpers

  describe '#index' do
    context 'when not logged in' do
      before { get :index, params: { customer_id: 1 } }

      it_behaves_like 'a protected action'
    end
  end

  describe '#show' do
    context 'when not logged in' do
      before { get :show, params: { customer_id: 1, id: 1 } }

      it_behaves_like 'a protected action'
    end
  end


  describe '#update' do
    context 'when not logged in' do
      before { put :update, params: { customer_id: 1, id: 1 } }

      it_behaves_like 'a protected action'
    end
  end
end

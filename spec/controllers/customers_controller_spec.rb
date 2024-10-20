# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CustomersController, type: :controller do
  include Devise::Test::ControllerHelpers

  describe '#index' do
    context 'when not logged in' do
      before { get :index }

      it_behaves_like 'a protected action'
    end
  end

  describe '#show' do
    context 'when not logged in' do
      before { get :show, params: { id: 1 } }

      it_behaves_like 'a protected action'
    end
  end

  describe '#create' do
    context 'when not logged in' do
      before { post :create, params: {} }

      it_behaves_like 'a protected action'
    end
  end

  describe '#update' do
    context 'when not logged in' do
      before { put :update, params: { id: 1 } }

      it_behaves_like 'a protected action'
    end
  end

  describe '#destroy' do
    context 'when not logged in' do
      before { delete :destroy, params: { id: 1 } }

      it_behaves_like 'a protected action'
    end
  end
end

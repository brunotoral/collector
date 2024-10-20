# frozen_string_literal: true

RSpec.shared_examples 'a protected action' do
  it 'redirects to login page' do
    expect(response).to redirect_to new_user_session_url
  end
end

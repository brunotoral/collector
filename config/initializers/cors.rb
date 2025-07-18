# frozen_string_literal: true

Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins "http://localhost:5000" # Substitua pela URL EXATA do seu front-end
    resource "*", headers: :any, methods: [ :get, :post, :put, :patch, :delete, :options, :head ] # credentials: true
  end
end

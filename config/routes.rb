Rails.application.routes.draw do
  resources :customers do
    resources :invoices, except: %i[new create destroy]
  end

  namespace :customers do
    resources :invoices
  end

  get "/react/nav_bar", to: "react#nav_bar"
  get "/react/customers", to: "react#customers"
  get "/react/invoice_reports", to: "react#invoice_reports"
  get "/react/customers/new", to: "react#new_customer"
  post "/react/customers", to: "react#create_customer"
  get "/react/foobar", to: "react#foobar"
  get "/react/address", to: "react#address"
  get "/react/customer/edit", to: "react#edit_customer"
  put "/react/customer_update", to: "react#update_customer"

  get "invoice_reports",  to: "invoice_reports#index"

  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Defines the root path route ("/")
  root "customers#index"
end

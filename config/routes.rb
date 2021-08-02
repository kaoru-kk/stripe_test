Rails.application.routes.draw do
  devise_for :users
  root 'pages#index'

  get 'subscriptions/new' => 'subscriptions#new'
  get 'subscriptions/new_maro' => 'subscriptions#new_maro'
  get 'subscriptions/create_subscription' => 'subscriptions#create_subscription'
  get 'subscriptions/cancel_subscription' => 'subscriptions#cancel_subscription'
  post 'subscriptions/webhook' => 'subscriptions#webhook'
  resources :messages
  # post 'subscriptions/create_customer' => 'subscriptions#create_customer'
end

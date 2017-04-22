Rails.application.routes.draw do
  resources :batch_montages, only: [:new, :create, :show]
  resources :montages, only: [:show], constraints: { format: 'jpg' }
  root to: 'batch_montages#new'
end

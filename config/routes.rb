Rails.application.routes.draw do
  resources :batch_montages, only: [:new, :create, :show]
  root to: 'batch_montages#new'
end

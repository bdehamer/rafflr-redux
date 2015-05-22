Rails.application.routes.draw do
  root 'raffles#index'
  get 'list', to: 'raffles#list'
  resources :raffles
end

Rails.application.routes.draw do
  root 'raffles#index'
  get 'list', to: 'raffles#list'
  post 'raffles_raffle', to: 'raffles#raffle'
  resources :raffles
end

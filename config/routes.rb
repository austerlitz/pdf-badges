Rails.application.routes.draw do
  root 'badges#index'

  resources :badges, only: [:index, :create, :show]
end

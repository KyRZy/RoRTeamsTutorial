Rails.application.routes.draw do
  resources :teams
  devise_for :users
  get 'home/index'
  get 'home/tutorial'
  root 'home#index'
end

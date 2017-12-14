Rails.application.routes.draw do
  resources :teams
  devise_for :users
  get 'home/index'
  get 'home/tutorial'
  post 'join_existing_team' => 'teams#join_existing_team'
  post 'team/:id/leave_team_path' => 'teams#leave_team', as: 'leave_team'
  root 'home#index'
end

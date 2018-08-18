Rails.application.routes.draw do
  root to: 'campaigns#index'
  resources :campaigns, only: [:index, :show]
end

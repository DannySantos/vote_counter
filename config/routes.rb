Rails.application.routes.draw do
  resources :campaigns, only: [:index]
end

Procurement::Engine.routes.draw do

  root to: redirect('/procurement/requests')

  resources :budget_periods, only: [:index, :create]

  resources :requests, only: [:index, :create]

  resources :users, only: [] do
    resources :requests, only: [:index, :create]
  end

end

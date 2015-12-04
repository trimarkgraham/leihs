Procurement::Engine.routes.draw do

  root to: 'application#root'

  resources :budget_periods, only: [:index, :create, :destroy]

  resources :requests, only: [] do
    collection do
      get :filter_overview
    end
  end

  resources :users, only: [:index, :create] do
    resources :requests, only: [] do
      collection do
        get :overview
      end
    end
    scope format: true, constraints: {format: 'csv'} do
      resources :budget_periods, only: [] do
        resources :requests, only: [:index]
      end
    end
  end

  resources :groups do
    resources :requests, only: [] do
      collection do
        get :overview
      end
    end
    resources :users, only: [] do
      resources :budget_periods, only: [] do
        resources :requests, only: [:index, :create, :destroy] do
          member do
            put :move
          end
        end
      end
    end
    scope format: true, constraints: {format: 'csv'} do
      resources :budget_periods, only: [] do
        resources :requests, only: [:index]
      end
    end
    resources :templates, only: [:index, :create]
  end

  resources :models, only: :index
  resources :suppliers, only: :index
  resources :locations, only: :index

  resources :organizations

end

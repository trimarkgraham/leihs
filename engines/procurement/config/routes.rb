Procurement::Engine.routes.draw do

  root to: redirect('/procurement/requests')

  resources :requests
end

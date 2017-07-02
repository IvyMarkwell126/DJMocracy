Rails.application.routes.draw do
  resources :votes
  resources :party_users
  resources :users
  resources :party_songs
  resources :parties
  resources :songs

  #nested users/:id/parties
  resources :users do
      resources :parties
  end

  get 'home/index'
  
  #resources :party
    
    #match 'auth/:provider/callback', to: 'sessions#create', via: [:get, :post]
    #match 'auth/failure', to: redirect('/'), via: [:get, :post]
    #match 'signout', to: 'sessions#destroy', as: 'signout', via: [:get, :post]

    root 'home#index'
end

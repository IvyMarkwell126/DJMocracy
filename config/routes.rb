Rails.application.routes.draw do
  resources :votes
  resources :party_users
  resources :users
  resources :party_songs
  resources :parties
  resources :songs

  resources :users, shallow: true do
      resources :parties
      resources :party_users
  end

  resources :users do
     get '/parties/:id', to: 'parties#show', as: 'party'
  end

  get 'home/index'
  post 'parties/add_song'
  post 'parties/leave_party'
  
  #resources :party
    
    #match 'auth/:provider/callback', to: 'sessions#create', via: [:get, :post]
    #match 'auth/failure', to: redirect('/'), via: [:get, :post]
    #match 'signout', to: 'sessions#destroy', as: 'signout', via: [:get, :post]

    root 'home#index'
end

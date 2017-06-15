Rails.application.routes.draw do
  get 'home/index'

    resources :playlists
    resources :start_party
    resources :join_party
    resources :party

    root 'home#index'
end

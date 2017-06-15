Rails.application.routes.draw do
  resources :party_songs
  resources :parties
  resources :songs
  get 'home/index'

    resources :playlists
    resources :party

    root 'home#index'
end

Rails.application.routes.draw do
  get 'home/index'

    resources :playlists

    root 'home#index'
end

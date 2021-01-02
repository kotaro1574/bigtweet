Rails.application.routes.draw do
  resources :posts, only: [:create]
  root to: "posts#new"
  post 'make', to: 'posts#make'
end

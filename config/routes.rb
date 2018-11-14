Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: 'devise/registrations',
    sessions: 'sessions',
    confirmations: 'devise/confirmations',
    password: 'devise/password',
    omniauth_callbacks: 'users/omniauth_callbacks' }

  get 'projects/entry'
  post 'projects/entry' => 'projects#create'
  delete 'projects/entry' => 'projects#destroy'
  get 'projects/:id', to: 'projects#show', as: 'projects_show'

  # get 'users', to: 'users#index'
  # root 'home#index'
  get 'home', to: 'home#index'
  root 'users#index'
  get 'users/index'
  # get 'users', to 'users#index', as:'users'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end

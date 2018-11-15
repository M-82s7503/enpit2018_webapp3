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
  get 'projects/edit/:id', to: 'projects#edit', as: 'projects_edit'
  patch 'projects/edit/:id' => 'projects#update'
  get 'home', to: 'home#index'

  root 'users#index'
  get 'users', to: 'users#index'
  get 'users/setting', to: 'users#setting'
  # get 'users', to: 'users#index', as:'users'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end

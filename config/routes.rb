Rails.application.routes.draw do

  get 'projects/entry'
  get 'users/index'
  #root 'tops#index'
  # get 'tops/show'
  #devise_for :users
  root 'home#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  # root to: "home#index"
end

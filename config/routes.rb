Rails.application.routes.draw do

  get 'pages/inputurl'
  get 'pages/user'
  #root 'tops#index'
  # get 'tops/show'
  #devise_for :users
  root 'home#top'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  # root to: "home#index"
end

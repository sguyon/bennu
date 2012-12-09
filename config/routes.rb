Bennu::Application.routes.draw do

  match '/stickers/activate_index' => 'stickers#activate_index', :via => :get
  match '/stickers/activate/:id' => 'stickers#activate', :via => :get
  match '/stickers/import' => 'stickers#import', :via => :get
  match '/stickers/upload_import' => 'stickers#upload_import', :via => :post

  resources :stickers

  mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'

  authenticated :user do
    root :to => 'home#index'
  end
  root :to => "home#index"
  devise_for :users
  resources :users


end
Rpglogger::Application.routes.draw do
  root :to => 'log_books#index'

  match "/auth/:provider/callback" => "sessions#create"
  match "/auth/failure" => "sessions#failure"
  match "/signout" => "sessions#destroy", :as => :signout
  
  resource :user_sessions
  resource :account, :controller => "users"
  
  resources :games
  resources :users
  resources :log_books
  resources :sections
  resources :section_properties
  resources :world_objects
end

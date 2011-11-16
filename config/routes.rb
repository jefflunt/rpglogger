Rpglogger::Application.routes.draw do
  resource :user_sessions
  resource :account, :controller => "users"
  
  resources :games
  resources :users
  resources :log_books
  resources :sections
  resources :section_properties
  resources :world_objects
  root :to => 'log_books#index'
end

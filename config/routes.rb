Rpglogger::Application.routes.draw do
  resource :user_sessions
  resource :account, :controller => "users"
  
  resources :games
  resources :users
  resources :log_books
  resources :world_objects
  resources :locations
  resources :quests
  resources :notes_entries
  resources :characters
  root :to => 'log_books#index'
end

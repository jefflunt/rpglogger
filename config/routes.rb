Rpglogger::Application.routes.draw do
  resource :user_sessions
  resource :account, :controller => "users"
  
  resources :games
  resources :users
  resources :log_books
  root :to => 'log_books#index'
end

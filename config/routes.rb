Rpglogger::Application.routes.draw do
  root :to => 'log_books#index'

  match "/auth/:provider/callback" => "sessions#create"
  match "/auth/failure" => "sessions#failure"
  match "/signout" => "sessions#destroy", :as => :signout
  
  resource :sessions
  resource :account, :controller => "users"
  
  resources :games, :users

  resources :log_books do
    resources :sections
    resources :shares
  end
  
  resources :sections do
    resources :section_properties
    resources :world_objects do
      resources :world_object_properties
    end
  end
  
end

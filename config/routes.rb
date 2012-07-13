Rpglogger::Application.routes.draw do
  root :to => 'log_books#index'

  match "/auth/:provider/callback" => "sessions#create"
  match "/auth/failure" => "sessions#failure"
  match "/signout" => "sessions#destroy", :as => :signout
  
  resource :sessions
  resource :account, :controller => "users"
  
  resources :games, :users

  resources :log_books do
    put :untrash, on: :member
    
    resources :sections
    resources :shares
  end
  
  resources :sections do
    put :untrash, on: :member
    
    resources :section_properties
    resources :world_objects do
      put :untrash, on: :member
      
      resources :world_object_properties
    end
  end
  
end

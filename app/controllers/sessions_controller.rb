class SessionsController < ApplicationController
  skip_authorization_check
  
  def create
    auth = request.env["omniauth.auth"]

    user = User.find_by_provider_and_uid(auth["provider"], auth["uid"]) || User.create_with_omniauth(auth)
    session[:user_id] = user.id
    
    if user.owned_and_shared_log_books.count == 0
      redirect_to new_log_book_path, :notice => "Signed in."
    else
      redirect_to log_books_path, :notice => "Signed in."
    end
  end

  def destroy
    session[:user_id] = nil
    flash[:notice] = "Signed out."
    redirect_to root_url, :notice => "Signed out."
  end
  
  def failure
    redirect_to root_url
  end
end
class SessionsController < ApplicationController
  skip_authorization_check
  
  def create
    auth = request.env["omniauth.auth"]
#    raise auth.to_yaml

    user = User.find_by_provider_and_uid(auth["provider"], auth["uid"]) || User.create_with_omniauth(auth)
    session[:user_id] = user.id
    redirect_to log_books_path, :notice => "Signed in!"
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url, :notice => "Signed out!"
  end
  
  def failure
    redirect_to root_url
  end
end
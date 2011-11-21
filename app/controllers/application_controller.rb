class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :current_user
  check_authorization

  rescue_from CanCan::AccessDenied do |exception|
    flash[:error] = "You don't have access to that page."
    redirect_back_or root_url
  end

  private
    def current_user
      @current_user ||= User.find(session[:user_id]) if session[:user_id]
    end
    
    def redirect_back_or(path)
      redirect_to :back
      rescue ActionController::RedirectBackError
        redirect_to path
    end
end

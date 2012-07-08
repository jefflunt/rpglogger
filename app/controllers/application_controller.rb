class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :current_user
  check_authorization

  rescue_from CanCan::AccessDenied do |exception|
    flash[:error] = "You don't have access to that."
    redirect_back_or root_url
  end

  private
    def current_user
      @current_user ||= User.find(session[:user_id]) if session[:user_id]
    end
    
    def current_ability
      @current_ability ||= Ability.new(current_user, params)
    end
    
    def redirect_back_or(path, response_status = {})
      redirect_to :back, response_status
      rescue ActionController::RedirectBackError
        redirect_to path, response_status
    end
end

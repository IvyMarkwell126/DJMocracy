class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  private
  def current_user
      @current_user ||= User.find(session[:user_id]) if session[:user_id]
      user_var = @current_user
      puts user_var
  end
  helper_method :current_user

end

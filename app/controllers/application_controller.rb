class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  after_action :allow_iframe

  rescue_from SecurityError, with: :not_signed_in


  def current_user
    if session[:cookie] == cookies[:chalmersItAuth] && session[:user].present?
      @user ||= User.find(session[:user])
    else
      reset_session
      @user = User.find_by_token cookies[:chalmersItAuth]
      session[:cookie] = cookies[:chalmersItAuth]
      session[:user] = @user.cid
    end
    @user
  end
  helper_method :current_user

  private
    def allow_iframe
      response.headers['X-Frame-Options'] = 'ALLOW-FROM https://chalmers.it'
    end

    def not_signed_in
      redirect_to "https://account.chalmers.it/?redirect_to=https://hue.chalmers.it"
    end
end

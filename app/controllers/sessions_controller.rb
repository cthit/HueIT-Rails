class SessionsController < ApplicationController
  protect_from_forgery

  def create
    auth = request.env["omniauth.auth"]
    session[:user_id] = auth.uid
    session[:token] = auth.credentials.token
    redirect_to root_url, :notice => t('signed_in')
  end

  def destroy
    session[:user_id] = nil
    session[:token] = nil
    redirect_to logout_path(root_url)
  end
end

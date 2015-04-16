class SessionsController < ApplicationController
  def new
    redirect_to auth_path('spotify')
  end

  def create
    user = User.find_or_create_by_auth(request.env['omniauth.auth'])
    session[:user_id] = user.id
    redirect_to root_url, notice: 'Signed in!'
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url, notice: 'Signed out!'
  end
end

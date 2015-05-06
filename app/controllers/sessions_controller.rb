class SessionsController < ApplicationController
  def create
    user = User.upsert_with_auth(request.env['omniauth.auth'])
    # Asynchronously refresh the user's playlists
    UserPlaylistsJob.new.perform(user)
    session[:user_id] = user.id
    redirect_to dashboard_path
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path, notice: 'Signed out!'
  end
end

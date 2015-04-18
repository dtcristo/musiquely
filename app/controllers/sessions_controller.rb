class SessionsController < ApplicationController
  def create
    user = User.find_or_create_by_auth(request.env['omniauth.auth'])
    # Asynchronously refresh the user's playlists
    SpotifyPlaylistsJob.perform_later(user)
    session[:user_id] = user.id
    redirect_to dashboard_path
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path, notice: 'Signed out!'
  end
end

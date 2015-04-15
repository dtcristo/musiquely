class SessionsController < ApplicationController
  def create
    auth = request.env['omniauth.auth']

    # Get or create the user
    user = User.find_by_spotify_id(auth['info']['id'])
    if (user)
      # Persist the user's latest Spotify auth data
      user.spotify_auth = auth
      user.save
    else
      user = User.create_with_omniauth(auth)
    end

    session[:user_id] = user.id
    redirect_to root_url, notice: 'Signed in!'
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url, notice: 'Signed out!'
  end
end

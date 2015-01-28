class AuthController < ApplicationController
  def spotify
    @spotify_user = RSpotify::User.new(request.env['omniauth.auth'])
    @spotify_playlists = Array.new

    # Get all of the user's playlists, 50 at a time
    offset = 0
    loop do
      current_playlists = @spotify_user.playlists limit: 50, offset: offset
      @spotify_playlists.concat current_playlists
      # Debug: print progress
      puts "@spotify_playlists.count = " + @spotify_playlists.count.to_s
      # Stop if we got less than 50
      break if current_playlists.count < 50
      offset += 50
    end
  end
end

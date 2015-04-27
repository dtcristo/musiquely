# Refresh the User's Playlists from Spotify
class UserPlaylistsJob < ActiveJob::Base
  queue_as :default

  def perform(user)
    # Build an array of Spotify playlists
    spotify_playlists = get_playlists(user.spotify_user)
    UserPlaylist.upsert_from_spotify(spotify_playlists, user)
  end

  def get_playlists(spotify_user)
    spotify_playlists = []
    # Get all of the user's playlists, 50 at a time
    offset = 0
    loop do
      current_playlists = spotify_user.playlists(limit: 50, offset: offset)
      spotify_playlists.concat(current_playlists)
      # Debug: print progress
      puts 'spotify_playlists.count = ' + spotify_playlists.count.to_s
      # Stop if we got less than 50
      break if current_playlists.count < 50
      offset += 50
    end
    return spotify_playlists
  end
end

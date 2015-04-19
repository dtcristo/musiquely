# Refresh the user's playlists from Spotify
class SpotifyPlaylistsJob < ActiveJob::Base
  queue_as :default

  def perform(user)
    # Build an array of Spotify playlists
    spotify_playlists = get_playlists(user.spotify_user)
    # Update or create the Playlist records
    spotify_playlists.each do |spotify_playlist|
      Playlist.update_or_create_from_spotify(spotify_playlist, user)
    end
  end

  def get_playlists(spotify_user)
    spotify_playlists = []
    # Get all of the user's playlists, 50 at a time
    offset = 0
    loop do
      current_playlists = spotify_user.playlists(limit: 50, offset: offset)
      spotify_playlists.concat(current_playlists)
      # Debug: print progress
      puts "spotify_playlists.count = " + spotify_playlists.count.to_s
      # Stop if we got less than 50
      break if current_playlists.count < 50
      offset += 50
    end
    return spotify_playlists
  end
end

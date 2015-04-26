# Refresh the playlist's tracks from Spotify
class SpotifyTracksJob < ActiveJob::Base
  queue_as :default

  def perform(playlist)
    # Build an array of Spotify tracks
    spotify_tracks = get_tracks(playlist.spotify_playlist)
    # Update or create the Entry records
    Entry.import_from_spotify(spotify_tracks, playlist)
  end

  def get_tracks(spotify_playlist)
    spotify_tracks = []
    # Get all of the playlist's tracks, 100 at a time
    offset = 0
    loop do
      current_tracks = spotify_playlist.tracks(limit: 100, offset: offset)
      spotify_tracks.concat(current_tracks)
      # Debug: print progress
      puts "spotify_tracks.count = " + spotify_tracks.count.to_s
      # Stop if we got less than 100
      break if current_tracks.count < 100
      offset += 100
    end
    return spotify_tracks
  end
end

# Refresh the Playlist's Entries from Spotify
class EntriesJob < ActiveJob::Base
  queue_as :default

  def perform(user_playlist)
    playlist = user_playlist.playlist
    spotify_playlist = user_playlist.spotify_playlist

    old_snapshot_id = playlist.snapshot_id
    new_snapshot_id = spotify_playlist.snapshot_id

    # Nothing to do if playlist hasn't changed
    return if new_snapshot_id == old_snapshot_id

    # Build an array of Spotify tracks
    spotify_tracks = get_tracks(spotify_playlist)
    # Update or create the Entry records
    import_from_spotify(spotify_tracks, playlist)
    playlist.update(snapshot_id: new_snapshot_id)
  end

  def get_tracks(spotify_playlist)
    spotify_tracks = []
    # Get all of the playlist's tracks, 100 at a time
    offset = 0
    loop do
      current_tracks = spotify_playlist.tracks(limit: 100, offset: offset)
      spotify_tracks.concat(current_tracks)
      # Debug: print progress
      puts 'spotify_tracks.count = ' + spotify_tracks.count.to_s
      # Stop if we got less than 100
      break if current_tracks.count < 100
      offset += 100
    end
    return spotify_tracks
  end

  def import_from_spotify(spotify_tracks, playlist)
    # Build values of each Entry
    values = []
    position = 0

    spotify_tracks.each do |spotify_track|
      track = Track.update_or_create_from_spotify(spotify_track)
      values << [playlist.id, track.id, position += 1]
    end

    # Delete all Entries for this Playlist
    Entry.where(playlist: playlist).delete_all

    columns = [:playlist_id, :track_id, :position]
    Entry.import(columns, values)
  end
end

# Refresh the Playlist's Entries from Spotify
class EntriesJob < ActiveJob::Base
  queue_as :default

  def perform(playlist)
    spotify_playlist = playlist.spotify_playlist

    old_snapshot_id = playlist.snapshot_id
    new_snapshot_id = spotify_playlist.snapshot_id

    # Nothing to do if playlist hasn't changed
    return if new_snapshot_id == old_snapshot_id

    spotify_tracks = get_spotify_tracks(spotify_playlist)

    # Update or create the Entry records
    upsert_spotify_tracks_for_playlist(spotify_tracks, playlist)

    # Save the new snapshot_id and set a loaded time
    playlist.update(snapshot_id: new_snapshot_id, loaded_at: UpsertHelper.timestamp)
  end

  def get_spotify_tracks(spotify_playlist)
    # Build an array of Spotify tracks
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

  def upsert_spotify_tracks_for_playlist(spotify_tracks, playlist)
    # Build a hash of the Spotify tracks, later we add the track_id from our DB
    spotify_tracks_h = {}
    spotify_tracks.each do |spotify_track|
      spotify_tracks_h[spotify_track.id] = { spotify_track: spotify_track }
    end

    # Update or insert Tracks from Spotify
    Upsert.batch(Track.connection, :tracks) do |upsert|
      spotify_tracks.each do |spotify_track|
        timestamp = UpsertHelper.timestamp
        upsert.row({ spotify_id: spotify_track.id },
          name: spotify_track.name, artist: spotify_track.artists.first.name,
          preview_url: spotify_track.preview_url,
          created_at: timestamp, updated_at: timestamp)
      end
    end

    # Pluck the ids of the Tracks we just upserted
    ids = Track.where(spotify_id: spotify_tracks_h.keys).pluck(:id, :spotify_id)

    # Add track_ids to the Spotify tracks hash
    ids.each do |id_pair|
      spotify_tracks_h[id_pair[1]][:track_id] = id_pair[0]
    end

    position = 0
    # Update or insert Entries for each position and Track in the Playlist
    Upsert.batch(Entry.connection, :entries) do |upsert|
      spotify_tracks.each do |spotify_track|
        timestamp = UpsertHelper.timestamp
        upsert.row({ playlist_id: playlist.id, position: position += 1 },
          track_id: spotify_tracks_h[spotify_track.id][:track_id],
          created_at: timestamp, updated_at: timestamp)
      end
    end

    # Delete all other Entries for the Playlist
    Entry.where(playlist: playlist).where.not(position: (1..spotify_tracks.count).to_a).delete_all
  end
end

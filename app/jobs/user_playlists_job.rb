# Refresh the User's Playlists from Spotify
class UserPlaylistsJob < ActiveJob::Base
  queue_as :default

  def perform(user)
    spotify_playlists = get_spotify_playlists(user.spotify_user)
    upsert_spotify_playlists_for_user(spotify_playlists, user)
  end

  def get_spotify_playlists(spotify_user)
    # Build an array of Spotify playlists
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
    spotify_playlists
  end

  def upsert_spotify_playlists_for_user(spotify_playlists, user)
    # Build a hash of the Spotify playlists and their ordering
    spotify_playlists_hash = {}
    position = 0
    spotify_playlists.each do |spotify_playlist|
      spotify_playlists_hash[spotify_playlist.id] = [spotify_playlist, position += 1]
    end

    # Update or insert Playlists from Spotify
    Upsert.batch(Playlist.connection, :playlists) do |upsert|
      spotify_playlists.each do |spotify_playlist|
        timestamp = UpsertHelper.timestamp
        upsert.row({ spotify_id: spotify_playlist.id }, name: spotify_playlist.name,
          created_at: timestamp, updated_at: timestamp)
      end
    end

    # Pluck the ids of the Playlists we just upserted
    ids = Playlist.where(spotify_id: spotify_playlists_hash.keys).pluck(:id, :spotify_id)

    # Update or insert UserPlaylists for each of the Playlists
    Upsert.batch(UserPlaylist.connection, :user_playlists) do |upsert|
      ids.each do |id_pair|
        timestamp = UpsertHelper.timestamp
        upsert.row({ user_id: user.id, playlist_id: id_pair[0] },
          position: spotify_playlists_hash[id_pair[1]][1], created_at: timestamp, updated_at: timestamp)
      end
    end

    # Delete all other UserPlaylists
    UserPlaylist.where(user: user).where.not(playlist_id: ids.transpose[0]).delete_all
  end
end

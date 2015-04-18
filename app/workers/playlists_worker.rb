class PlaylistsWorker
  include Sidekiq::Worker
  
  def refresh_playlists_for_user(user_id)
    spotify_user = User.find(user_id).spotify_user

    spotify_playlists = []

    # Get all of the user's playlists, 50 at a time
    offset = 0
    loop do
      current_playlists = spotify_user.playlists(limit: 50, offset: offset)
      spotify_playlists.concat current_playlists
      # Debug: print progress
      puts "spotify_playlists.count = " + spotify_playlists.count.to_s
      # Stop if we got less than 50
      break if current_playlists.count < 50
      offset += 50
    end

    # Update or create the playlist records
    spotify_playlists.each do |spotify_playlist|
      Playlist.update_or_create_from_spotify(spotify_playlist, user_id)
    end
  end
end

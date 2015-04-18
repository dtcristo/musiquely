class Playlist < ActiveRecord::Base
  belongs_to :user

  def self.update_or_create_from_spotify(spotify_playlist, user_id)
    playlist = find_by_spotify_id(spotify_playlist.id)
    if (playlist)
      # Update playlist name
      playlist.name = spotify_playlist.name
      playlist.save
    else
      playlist = create_from_spotify(spotify_playlist, user_id)
    end
    return playlist
  end

  def self.create_from_spotify(spotify_playlist, user_id)
    create! do |playlist|
      playlist.spotify_id = spotify_playlist.id
      playlist.user_id = user_id
      playlist.name = spotify_playlist.name
    end
  end

  def spotify_playlist
    RSpotify::Playlist.find(user.spotify_user.id, spotify_id)
  end
end

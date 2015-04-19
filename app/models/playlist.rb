class Playlist < ActiveRecord::Base
  has_and_belongs_to_many :users
  has_many :tracks, through: :entries

  def self.update_or_create_from_spotify(spotify_playlist, user)
    playlist = find_by_spotify_id(spotify_playlist.id)
    if (playlist)
      # Update playlist name
      playlist.name = spotify_playlist.name
      playlist.save
    else
      playlist = create_from_spotify(spotify_playlist, user)
    end
    return playlist
  end

  def self.create_from_spotify(spotify_playlist, user)
    create! do |playlist|
      playlist.spotify_id = spotify_playlist.id
      playlist.users << user
      playlist.name = spotify_playlist.name
    end
  end

  def spotify_playlist
    RSpotify::Playlist.find(users.first.spotify_user.id, spotify_id)
  end
end

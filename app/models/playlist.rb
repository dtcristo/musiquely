class Playlist < ActiveRecord::Base
  has_many :user_playlists
  has_many :users, through: :user_playlists
  has_many :entries
  has_many :tracks, through: :entries

  validates :spotify_id, presence: true, uniqueness: true

  def self.update_or_create_from_spotify(spotify_playlist)
    playlist = find_by_spotify_id(spotify_playlist.id)
    if (playlist)
      playlist.update(name: spotify_playlist.name)
    else
      playlist = create_from_spotify(spotify_playlist)
    end
    return playlist
  end

  def self.create_from_spotify(spotify_playlist)
    create! do |playlist|
      playlist.spotify_id = spotify_playlist.id
      playlist.name = spotify_playlist.name
    end
  end
end

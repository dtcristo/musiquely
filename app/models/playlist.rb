class Playlist < ActiveRecord::Base
  has_many :user_playlists
  has_many :users, through: :user_playlists
  has_many :entries
  has_many :tracks, through: :entries

  validates :spotify_id, presence: true, uniqueness: true
  validates :owner_id, presence: true

  def spotify_playlist
    RSpotify::Playlist.find(owner_id, spotify_id)
  end
end

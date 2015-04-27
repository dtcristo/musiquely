class Playlist < ActiveRecord::Base
  has_many :user_playlists
  has_many :users, through: :user_playlists
  has_many :entries
  has_many :tracks, through: :entries

  validates :spotify_id, presence: true, uniqueness: true
end

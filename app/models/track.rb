class Track < ActiveRecord::Base
  has_many :entries
  has_many :playlists, through: :entries

  validates :spotify_id, presence: true, uniqueness: true

  def spotify_track
    RSpotify::Track.find(spotify_id)
  end
end

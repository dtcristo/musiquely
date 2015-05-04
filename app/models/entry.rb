class Entry < ActiveRecord::Base
  belongs_to :playlist
  belongs_to :track

  validates :playlist_id, :track_id, :position, presence: true
  # The position is unique within a given Playlist
  validates :position, uniqueness: { scope: :playlist_id }
end

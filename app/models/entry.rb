class Entry < ActiveRecord::Base
  belongs_to :playlist
  belongs_to :track

  validates :playlist_id, :track_id, presence: true
end

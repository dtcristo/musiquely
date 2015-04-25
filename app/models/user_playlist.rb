class UserPlaylist < ActiveRecord::Base
  belongs_to :user
  belongs_to :playlist

  validates :playlist_id, uniqueness: { scope: :user_id }
end

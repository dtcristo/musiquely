class UserPlaylist < ActiveRecord::Base
  belongs_to :user
  belongs_to :playlist
  has_many :entries, through: :playlist

  validates :user_id, :playlist_id, presence: true
  # The combination of user_id and playlist_id is unique
  validates :playlist_id, uniqueness: { scope: :user_id }

  def spotify_playlist
    RSpotify::Playlist.find(user.spotify_user.id, playlist.spotify_id)
  end
end

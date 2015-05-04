class UserPlaylist < ActiveRecord::Base
  belongs_to :user
  belongs_to :playlist
  has_many :entries, through: :playlist

  validates :user_id, :playlist_id, :position, presence: true
  # A playlist is unique for a given User
  validates :playlist_id, uniqueness: { scope: :user_id }
  # The positions are unique for a given User
  validates :position, uniqueness: { scope: :user_id }

  def spotify_playlist
    RSpotify::Playlist.find(user.spotify_user.id, playlist.spotify_id)
  end
end

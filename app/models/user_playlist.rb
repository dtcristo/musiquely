require 'upsert/active_record_upsert'

class UserPlaylist < ActiveRecord::Base
  belongs_to :user
  belongs_to :playlist
  has_many :entries, through: :playlist

  validates :user_id, :playlist_id, presence: true
  # The combination of [:playlist_id, :user_id] is unique
  validates :playlist_id, uniqueness: { scope: :user_id }

  def self.upsert_from_spotify(spotify_playlists, user)
    # Build values of each UserPlaylist
    values = []

    spotify_playlists.each do |spotify_playlist|
      playlist = Playlist.update_or_create_from_spotify(spotify_playlist)
      values << [user.id, playlist.id]
    end

    # Delete all UserPlaylists for this User
    UserPlaylist.where(user: user).delete_all

    columns = [:user_id, :playlist_id]
    UserPlaylist.import(columns, values)

    #Upsert.batch(Playlist.connection, :playlists) do |upsert|

    #end

    #spotify_playlist.each do |spotify_playlist|
    #  Playlist.upsert({ spotify_id: spotify_playlist.id }, name: spotify_playlist.name)
    #end
  end

  def spotify_playlist
    RSpotify::Playlist.find(user.spotify_user.id, playlist.spotify_id)
  end
end

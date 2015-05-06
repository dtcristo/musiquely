require 'upsert/active_record_upsert'

class User < ActiveRecord::Base
  has_many :user_playlists
  has_many :playlists, through: :user_playlists
  has_many :tracks, through: :playlists

  serialize :spotify_auth

  validates :spotify_id, presence: true, uniqueness: true
  validates :spotify_auth, presence: true

  def self.upsert_with_auth(auth)
    spotify_user = RSpotify::User.new(auth)
    timestamp = UpsertHelper.timestamp
    User.upsert({spotify_id: spotify_user.id}, spotify_auth: auth.to_yaml,
      name: spotify_user.display_name, email: spotify_user.email,
      created_at: timestamp, updated_at: timestamp)
    # Return the User
    User.find_by(spotify_id: spotify_user.id)
  end

  def spotify_user
    RSpotify::User.new(spotify_auth)
  end
end

class User < ActiveRecord::Base
  serialize :spotify_auth
  has_and_belongs_to_many :playlists

  def self.find_or_create_by_auth(auth)
    user = find_by_spotify_id(auth['info']['id'])
    if (user)
      # Update user auth data
      user.spotify_auth = auth
      user.save
    else
      user = create_by_auth(auth)
    end
    return user
  end

  def self.create_by_auth(auth)
    spotify_user = RSpotify::User.new(auth)
    create! do |user|
      user.spotify_id = spotify_user.id
      user.spotify_auth = auth
      user.name = spotify_user.display_name
      user.email = spotify_user.email
    end
  end

  def spotify_user
    RSpotify::User.new(spotify_auth)
  end
end

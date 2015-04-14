class User < ActiveRecord::Base
  def self.create_with_omniauth(auth)
    spotify_user = RSpotify::User.new(auth)
    create! do |user|
      user.spotify_id = spotify_user.id
      user.name = spotify_user.display_name
      user.email = spotify_user.email
    end
  end
end

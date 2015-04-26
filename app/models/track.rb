class Track < ActiveRecord::Base
  has_many :entries
  has_many :playlists, through: :entries

  validates :spotify_id, presence: true, uniqueness: true

  def self.update_or_create_from_spotify(spotify_track)
    track = find_by_spotify_id(spotify_track.id)
    track = create_from_spotify(spotify_track) unless track
    return track
  end

  def self.create_from_spotify(spotify_track)
    create! do |track|
      track.spotify_id = spotify_track.id
      track.name = spotify_track.name
      track.artist = spotify_track.artists.first.name
    end
  end

  def spotify_track
    RSpotify::Track.find(spotify_id)
  end
end

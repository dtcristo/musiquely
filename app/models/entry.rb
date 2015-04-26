class Entry < ActiveRecord::Base
  belongs_to :playlist
  belongs_to :track

  validates :playlist_id, :track_id, presence: true

  def self.import_from_spotify(spotify_tracks, playlist)
    # Build values of each Entry
    values = []
    position = 0

    spotify_tracks.each do |spotify_track|
      track = Track.update_or_create_from_spotify(spotify_track)
      values << [playlist.id, track.id, position += 1]
    end

    # Delete all Entries for this Playlist
    Entry.where(playlist: playlist).delete_all

    columns = [:playlist_id, :track_id, :position]
    Entry.import(columns, values)
  end
end

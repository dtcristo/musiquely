class Entry < ActiveRecord::Base
  belongs_to :playlist
  belongs_to :track

  def self.import_from_spotify(spotify_tracks, playlist)
    # Build values of each entry
    values = []
    position = 0

    spotify_tracks.each do |spotify_track|
      track = Track.update_or_create_from_spotify(spotify_track)
      values << [playlist.id, track.id, position += 1]
    end

    # Delete all entries for this playlist
    Entry.where(playlist: playlist).delete_all

    columns = [:playlist_id, :track_id, :position]
    Entry.import(columns, values)
  end
end

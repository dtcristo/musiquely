class PlaylistsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_playlist, only: :show

  def index
    @playlists = current_user.playlists
  end

  def show
    playlist = Playlist.find_by_spotify_id(params[:spotify_id])
    #perform(playlist)
    @tracks = Track.all #.references(:playlists_tracks).where(playlist: playlist)
  end

  private

  def set_playlist
    @playlist = Playlist.find_by_spotify_id(params[:spotify_id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def playlist_params
    params[:playlist]
  end
end

class PlaylistsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_playlist, only: [:show, :refresh]

  def index
    @playlists = current_user.playlists
  end

  def refresh_index
    SpotifyPlaylistsJob.perform_later(current_user)
    redirect_to playlists_path, notice: "Your playlist index is being reloaded"
  end

  def show
    @entries = Entry.includes(:track).order(position: :asc).where(playlist: @playlist)
  end

  def refresh
    SpotifyTracksJob.perform_later(@playlist)
    redirect_to playlists_path, notice: "\"#{@playlist.name}\" is being reloaded"
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

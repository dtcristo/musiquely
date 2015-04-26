class PlaylistsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user_playlist, only: [:show, :refresh]

  def index
    @playlists = current_user.playlists
  end

  def refresh_index
    UserPlaylistsJob.new.perform(current_user)
    redirect_to playlists_path, notice: "Your playlist index is being reloaded"
  end

  def show
    @entries = Entry.includes(:track).order(position: :asc).where(playlist: @playlist)
  end

  def refresh
    EntriesJob.new.perform(@user_playlist)
    redirect_to playlists_path, notice: "\"#{@playlist.name}\" is being reloaded"
  end

  private

  def set_user_playlist
    # TODO: Fix this query
    #@playlist = Playlist.find_by_spotify_id(params[:spotify_id])
    #@user_playlist = UserPlaylist.find()
    @user_playlist = UserPlaylist.joins(:playlist).where(playlists: { spotify_id: params[:spotify_id] }).take
    @playlist = @user_playlist.playlist
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def playlist_params
    params[:playlist]
  end
end

class PlaylistsController < ApplicationController
  def index
    @playlists = current_user.playlists
  end
end

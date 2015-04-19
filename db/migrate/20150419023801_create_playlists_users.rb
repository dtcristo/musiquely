class CreatePlaylistsUsers < ActiveRecord::Migration
  def change
    create_table :playlists_users, id: false do |t|
      t.belongs_to :user, index: true
      t.belongs_to :playlist, index: true
    end
  end
end

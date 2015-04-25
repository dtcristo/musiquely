class CreateUserPlaylists < ActiveRecord::Migration
  def change
    create_table :user_playlists do |t|
      t.belongs_to :user, index: true
      t.belongs_to :playlist, index: true

      t.timestamps null: false
    end

    add_index :user_playlists, [:user_id, :playlist_id], unique: true
  end
end

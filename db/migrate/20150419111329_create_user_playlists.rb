class CreateUserPlaylists < ActiveRecord::Migration
  def change
    create_table :user_playlists do |t|
      t.belongs_to :user,     null: false, index: true
      t.belongs_to :playlist, null: false, index: true
      t.integer :position,    null: false

      t.timestamps null: false
    end

    add_index :user_playlists, [:user_id, :playlist_id], unique: true
    add_index :user_playlists, [:user_id, :position],    unique: true
  end
end

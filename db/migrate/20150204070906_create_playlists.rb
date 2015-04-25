class CreatePlaylists < ActiveRecord::Migration
  def change
    create_table :playlists do |t|
      t.string :spotify_id
      t.string :name

      t.timestamps null: false
    end

    add_index :playlists, :spotify_id, unique: true
  end
end

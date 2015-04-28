class CreatePlaylists < ActiveRecord::Migration
  def change
    create_table :playlists do |t|
      t.string :spotify_id, null: false
      t.string :snapshot_id
      t.string :name
      t.datetime :loaded_at

      t.timestamps null: false
    end

    add_index :playlists, :spotify_id, unique: true
  end
end

class CreateTracks < ActiveRecord::Migration
  def change
    create_table :tracks do |t|
      t.string :spotify_id, null: false
      t.string :name
      t.string :artist

      t.timestamps null: false
    end

    add_index :tracks, :spotify_id, unique: true
  end
end

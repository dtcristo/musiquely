class CreateTracks < ActiveRecord::Migration
  def change
    create_table :tracks do |t|
      t.string :spotify_id, index: true
      t.string :name
      t.string :artist

      t.timestamps null: false
    end
  end
end

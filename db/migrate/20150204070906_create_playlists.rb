class CreatePlaylists < ActiveRecord::Migration
  def change
    create_table :playlists do |t|
      t.string :spotify_id, index: true
      t.belongs_to :user, index: true
      t.string :name

      t.timestamps null: false
    end
  end
end

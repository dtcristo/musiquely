class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :spotify_id, null: false
      t.text :spotify_auth, null: false
      t.string :name
      t.string :email

      t.timestamps null: false
    end

    add_index :users, :spotify_id, unique: true
  end
end

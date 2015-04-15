class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :spotify_id
      t.text :spotify_auth
      t.string :name
      t.string :email

      t.timestamps null: false
    end

    add_index :users, :spotify_id
  end
end

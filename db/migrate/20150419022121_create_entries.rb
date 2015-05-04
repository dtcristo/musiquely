class CreateEntries < ActiveRecord::Migration
  def change
    create_table :entries do |t|
      t.belongs_to :playlist, null: false, index: true
      t.belongs_to :track,    null: false, index: true
      t.integer :position,    null: false

      t.timestamps null: false
    end

    add_index :entries, [:playlist_id, :position], unique: true
  end
end

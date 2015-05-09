class CreateTemplates < ActiveRecord::Migration
  def change
    create_table :templates do |t|
      t.belongs_to :user,     null: false
      t.belongs_to :playlist, null: false
      t.string :name,         null: false

      t.timestamps null: false
    end
  end
end

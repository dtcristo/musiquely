class CreateRules < ActiveRecord::Migration
  def change
    create_table :rules do |t|
      t.belongs_to :template, null: false

      t.timestamps null: false
    end
  end
end

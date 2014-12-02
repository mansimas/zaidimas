class CreateDrops < ActiveRecord::Migration
  def change
    create_table :drops do |t|
      t.string :name
      t.integer :health
      t.integer :strength

      t.timestamps
    end
  end
end

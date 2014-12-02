class CreateShops < ActiveRecord::Migration
  def change
    create_table :shops do |t|
      t.text :item
      t.integer :user_id
      t.integer :count
      t.integer :health
      t.integer :strength
      t.integer :experience
      t.integer :level
      t.integer :hp
      t.integer :money
      t.integer :min_dmg
      t.integer :max_dmg
      t.integer :speed
      t.integer :agility
      t.integer :defence
      t.integer :critical
      t.integer :critical_multiplier
      t.string :itemname
      t.integer :grade

      t.timestamps
    end
  end
end

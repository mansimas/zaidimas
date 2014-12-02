class CreateMonsters < ActiveRecord::Migration
  def change
    create_table :monsters do |t|
      t.string :name
      t.integer :level
      t.integer :health
      t.integer :strength
      t.integer :experience
      t.integer :attacker

      t.timestamps
    end
  end
end

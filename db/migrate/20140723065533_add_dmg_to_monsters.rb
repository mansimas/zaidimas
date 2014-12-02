class AddDmgToMonsters < ActiveRecord::Migration
  def change
    add_column :monsters, :min_dmg, :integer
    add_column :monsters, :max_dmg, :integer
    add_column :monsters, :speed, :integer
    add_column :monsters, :agility, :integer
    add_column :monsters, :defence, :integer
  end
end

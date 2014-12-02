class AddMaxhpToMonsters < ActiveRecord::Migration
  def change
    add_column :monsters, :max_hp, :integer
  end
end

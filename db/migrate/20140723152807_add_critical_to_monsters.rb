class AddCriticalToMonsters < ActiveRecord::Migration
  def change
    add_column :monsters, :critical, :integer
    add_column :monsters, :critical_multiplier, :integer
  end
end

class RemoveYposFromMonsters < ActiveRecord::Migration
  def self.up
    remove_column :monsters, :Ypos
  end
  def self.down
    add_column :monsters, :Ypos, :decimal
  end
end

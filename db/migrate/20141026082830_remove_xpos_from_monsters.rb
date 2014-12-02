class RemoveXposFromMonsters < ActiveRecord::Migration
  def self.up
    remove_column :monsters, :Xpos
  end
  def self.down
    add_column :monsters, :Xpos, :decimal
  end
end

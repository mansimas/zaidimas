class AddYposToMonsters < ActiveRecord::Migration
def self.up
  add_column :monsters, :Ypos, :integer
end
def self.down
  add_column :monsters, :Ypos, :integer
end
end

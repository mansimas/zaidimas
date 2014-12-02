class AddYpossToMigration < ActiveRecord::Migration
def self.up
  add_column :monsters, :Xpos, :integer
end
def self.down
  add_column :monsters, :Xpos, :integer
end
end

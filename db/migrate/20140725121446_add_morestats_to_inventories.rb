class AddMorestatsToInventories < ActiveRecord::Migration
  def change
    add_column :inventories, :count, :integer
    add_column :inventories, :health, :integer
    add_column :inventories, :strength, :integer
    add_column :inventories, :experience, :integer
    add_column :inventories, :level, :integer
    add_column :inventories, :hp, :integer
    add_column :inventories, :money, :integer
    add_column :inventories, :min_dmg, :integer
    add_column :inventories, :max_dmg, :integer
    add_column :inventories, :speed, :integer
    add_column :inventories, :agility, :integer
    add_column :inventories, :defence, :integer
    add_column :inventories, :critical, :integer
    add_column :inventories, :critical_multiplier, :integer
  end
end

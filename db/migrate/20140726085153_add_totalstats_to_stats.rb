class AddTotalstatsToStats < ActiveRecord::Migration
  def change
    add_column :stats, :total_health, :integer
    add_column :stats, :total_strength, :integer
    add_column :stats, :total_agility, :integer
    add_column :stats, :total_defence, :integer
  end
end

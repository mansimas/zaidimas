class AddGradesToStats < ActiveRecord::Migration
  def change
    add_column :stats, :weapon_grade, :integer
    add_column :stats, :armor_grade, :integer
    add_column :stats, :gloves_grade, :integer
    add_column :stats, :shoes_grade, :integer
    add_column :stats, :helmet_grade, :integer
  end
end

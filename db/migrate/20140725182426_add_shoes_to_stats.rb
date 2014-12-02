class AddShoesToStats < ActiveRecord::Migration
  def change
    add_column :stats, :shoes_name, :text
    add_column :stats, :shoes_user_id, :integer
    add_column :stats, :shoes_strength, :integer
    add_column :stats, :shoes_health, :integer
    add_column :stats, :shoes_agility, :integer
    add_column :stats, :shoes_level, :integer
    add_column :stats, :shoes_defence, :integer
  end
end

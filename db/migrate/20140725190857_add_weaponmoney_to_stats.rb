class AddWeaponmoneyToStats < ActiveRecord::Migration
  def change
    add_column :stats, :weapon_money, :integer
    add_column :stats, :armor_money, :integer
    add_column :stats, :gloves_money, :integer
    add_column :stats, :shoes_money, :integer
    add_column :stats, :helmet_money, :integer
  end
end

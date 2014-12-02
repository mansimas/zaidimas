class AddExtraWeaponsToStats < ActiveRecord::Migration
  def change
    add_column :stats, :weapon_itemname, :string
    add_column :stats, :armor_itemname, :string
    add_column :stats, :gloves_itemname, :string
    add_column :stats, :shoes_itemname, :string
    add_column :stats, :helmet_itemname, :string
  end
end

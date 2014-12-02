class RemoveSomeMoreUnusedColumnsFromStats < ActiveRecord::Migration
  def change
    remove_column :stats, :monster_max_dmg, :string
    remove_column :stats, :monster_min_dmg, :string
    remove_column :stats, :monster_money, :string
    remove_column :stats, :monster_exp, :string
    remove_column :stats, :monster_strength, :string
    remove_column :stats, :monster_name, :string
    remove_column :stats, :monster_hp, :string
    remove_column :stats, :monster, :string
  end
end

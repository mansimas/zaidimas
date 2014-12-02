class RemoveSomeUnusedColumnsFromStats < ActiveRecord::Migration
  def change
    remove_column :stats, :monster_defence, :string
    remove_column :stats, :monster_agility, :string
    remove_column :stats, :monster_speed, :string
  end
end

class AddMonsterhpToStats < ActiveRecord::Migration
  def change
    add_column :stats, :monster_hp, :integer
  end
end

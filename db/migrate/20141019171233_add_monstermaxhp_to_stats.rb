class AddMonstermaxhpToStats < ActiveRecord::Migration
  def change
    add_column :stats, :monster_max_hp, :integer
  end
end

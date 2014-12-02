class AddMonsterExpToStats < ActiveRecord::Migration
  def change
    add_column :stats, :monster_exp, :integer
  end
end

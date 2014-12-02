class AddMonsterToStats < ActiveRecord::Migration
  def change
    add_column :stats, :monster, :integer
  end
end

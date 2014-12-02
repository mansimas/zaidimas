class AddRankToMonsters < ActiveRecord::Migration
  def change
    add_column :monsters, :rang, :integer
  end
end

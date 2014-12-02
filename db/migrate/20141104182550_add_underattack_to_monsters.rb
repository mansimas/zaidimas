class AddUnderattackToMonsters < ActiveRecord::Migration
  def change
    add_column :monsters, :under_attack, :boolean
  end
end

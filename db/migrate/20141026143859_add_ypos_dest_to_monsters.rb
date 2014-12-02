class AddYposDestToMonsters < ActiveRecord::Migration
  def change
    add_column :monsters, :YposDest, :integer
    add_column :monsters, :XposDest, :integer
  end
end

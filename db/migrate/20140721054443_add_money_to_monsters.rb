class AddMoneyToMonsters < ActiveRecord::Migration
  def change
    add_column :monsters, :money, :integer
  end
end

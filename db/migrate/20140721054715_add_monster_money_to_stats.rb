class AddMonsterMoneyToStats < ActiveRecord::Migration
  def change
    add_column :stats, :monster_money, :integer
  end
end

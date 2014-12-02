class AddMoneyToStats < ActiveRecord::Migration
  def change
    add_column :stats, :money, :integer
  end
end

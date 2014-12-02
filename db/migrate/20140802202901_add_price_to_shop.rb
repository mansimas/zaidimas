class AddPriceToShop < ActiveRecord::Migration
  def change
    add_column :shops, :price, :integer
  end
end

class AddOneStatToInventories < ActiveRecord::Migration
  def change
    add_column :inventories, :itemname, :string
  end
end

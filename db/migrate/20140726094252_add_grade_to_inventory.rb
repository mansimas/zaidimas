class AddGradeToInventory < ActiveRecord::Migration
  def change
    add_column :inventories, :grade, :integer
  end
end

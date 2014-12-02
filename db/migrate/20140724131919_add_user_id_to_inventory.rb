class AddUserIdToInventory < ActiveRecord::Migration
  def change
    add_column :inventories, :user_id, :integer
  end
end

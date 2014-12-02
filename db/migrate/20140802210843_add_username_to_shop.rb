class AddUsernameToShop < ActiveRecord::Migration
  def change
    add_column :shops, :username, :string
  end
end

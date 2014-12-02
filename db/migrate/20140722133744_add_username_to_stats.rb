class AddUsernameToStats < ActiveRecord::Migration
  def change
    add_column :stats, :username, :string
  end
end

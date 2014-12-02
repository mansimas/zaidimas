class AddMedicinetimeToStats < ActiveRecord::Migration
  def change
    add_column :stats, :medicine_time, :integer
  end
end

class AddExpleftToStats < ActiveRecord::Migration
  def change
    add_column :stats, :exp_left, :integer
  end
end

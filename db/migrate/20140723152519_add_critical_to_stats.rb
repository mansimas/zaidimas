class AddCriticalToStats < ActiveRecord::Migration
  def change
    add_column :stats, :critical, :integer
    add_column :stats, :critical_multiplier, :integer
  end
end

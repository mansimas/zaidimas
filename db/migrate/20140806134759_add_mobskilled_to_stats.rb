class AddMobskilledToStats < ActiveRecord::Migration
  def change
    add_column :stats, :mobs_killed, :integer
  end
end

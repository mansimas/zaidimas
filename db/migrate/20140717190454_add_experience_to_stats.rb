class AddExperienceToStats < ActiveRecord::Migration
  def change
    add_column :stats, :experience, :integer
    add_column :stats, :level, :integer
  end
end

class AddAttackAllowToStats < ActiveRecord::Migration
  def change
    add_column :stats, :attack_allow, :boolean
  end
end

class AddEvasionToStats < ActiveRecord::Migration
  def change
    add_column :stats, :evasion, :integer
    add_column :stats, :accuracy, :integer
  end
end

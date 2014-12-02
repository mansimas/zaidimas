class AddEvasionToMonsters < ActiveRecord::Migration
  def change
    add_column :monsters, :evasion, :integer
    add_column :monsters, :accuracy, :integer
  end
end

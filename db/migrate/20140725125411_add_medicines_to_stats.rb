class AddMedicinesToStats < ActiveRecord::Migration
  def change
    add_column :stats, :medicine1, :integer
    add_column :stats, :medicine2, :integer
    add_column :stats, :medicine3, :integer
    add_column :stats, :medicine4, :integer
    add_column :stats, :medicine5, :integer
    add_column :stats, :medicine6, :integer
    add_column :stats, :medicine7, :integer
    add_column :stats, :medicine8, :integer
    add_column :stats, :medicine9, :integer
    add_column :stats, :medicine10, :integer
  end
end

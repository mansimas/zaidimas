class FixColumnName < ActiveRecord::Migration
  def change
    rename_column :shops, :item, :name	  
  end
end

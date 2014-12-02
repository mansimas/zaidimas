class ChangeItemForInventories < ActiveRecord::Migration
  change_table :inventories do |t|
    t.change :item, :text
  end
end

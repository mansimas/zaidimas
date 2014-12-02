class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.string :name
      t.integer :health
      t.integer :strength

      t.timestamps
    end
  end
end

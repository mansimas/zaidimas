class CreateStats < ActiveRecord::Migration
  def change
    create_table :stats do |t|
      t.integer :stat
      t.integer :health
      t.integer :strength
      t.references :user, index: true

      t.timestamps
    end
  end
end

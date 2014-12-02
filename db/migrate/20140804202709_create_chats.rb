class CreateChats < ActiveRecord::Migration
  def change
    create_table :chats do |t|
      t.integer :player_id
      t.string :username
      t.text :player_text

      t.timestamps
    end
  end
end

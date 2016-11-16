class CreateChatRooms < ActiveRecord::Migration
  def change
    create_table :chat_rooms, id: :uuid do |t|
      t.string :name, null: false
      t.jsonb :session_dump, null: false

      t.index :name, unique: true

      t.timestamps null: false
    end
  end
end

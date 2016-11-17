class AddOwnerToChatRooms < ActiveRecord::Migration
  def change
    add_reference :chat_rooms, :owner, null: false, index: true
  end
end

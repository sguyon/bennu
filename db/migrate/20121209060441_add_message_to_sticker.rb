class AddMessageToSticker < ActiveRecord::Migration
  def change
    add_column :stickers, :message_id, :integer
  end
end

class AddFieldsToSticker < ActiveRecord::Migration
  def change
    add_column :stickers, :product_id, :string
    add_column :stickers, :code, :string
    add_column :stickers, :user_id, :integer
    add_column :stickers, :production_date, :date
    add_column :stickers, :activated, :integer
    add_column :stickers, :verified, :integer
    add_column :stickers, :verifier, :string
  end
end
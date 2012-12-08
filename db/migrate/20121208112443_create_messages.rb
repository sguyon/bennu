class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.string :error
      t.string :confirm
      t.string :name

      t.timestamps
    end
  end
end

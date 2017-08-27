class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.string :title
      t.text :content
      t.integer :sender_id
      t.integer :recipient_id
      t.boolean :read, default: false

      t.timestamps null: false
    end
  end
end

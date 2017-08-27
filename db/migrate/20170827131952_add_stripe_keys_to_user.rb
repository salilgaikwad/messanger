class AddStripeKeysToUser < ActiveRecord::Migration
  def change
    add_column :users, :secret_key, :string
    add_column :users, :publishable_key, :string
  end
end

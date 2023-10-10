class AddTokenDigestAndAdminToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :admin, :boolean, default: false
    add_column :users, :token_digest, :string
  end
end

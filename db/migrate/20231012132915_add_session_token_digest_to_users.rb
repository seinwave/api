class AddSessionTokenDigestToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :session_token_digest, :string
  end
end

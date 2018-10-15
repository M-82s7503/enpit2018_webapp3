class AddGithubTokenToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :github_token, :string, null: false, after: :encrypted_password
  end
end

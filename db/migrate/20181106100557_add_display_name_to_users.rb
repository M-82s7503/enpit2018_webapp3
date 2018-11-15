class AddDisplayNameToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :display_name, :string, after: :username
  end
end

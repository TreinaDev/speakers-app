class AddUserNameToProfile < ActiveRecord::Migration[8.0]
  def change
    add_column :profiles, :username, :string
    add_index :profiles, :username, unique: true
  end
end

class AddCodeToEventContent < ActiveRecord::Migration[8.0]
  def change
    add_column :event_contents, :code, :string
    add_index :event_contents, :code, unique: true
  end
end

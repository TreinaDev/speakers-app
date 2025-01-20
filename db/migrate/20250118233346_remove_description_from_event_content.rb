class RemoveDescriptionFromEventContent < ActiveRecord::Migration[8.0]
  def change
    remove_column :event_contents, :description, :text
  end
end

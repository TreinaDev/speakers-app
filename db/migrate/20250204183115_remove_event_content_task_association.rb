class RemoveEventContentTaskAssociation < ActiveRecord::Migration[8.0]
  def change
    drop_table :event_task_contents
  end
end

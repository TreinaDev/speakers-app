class RemoveEventTask < ActiveRecord::Migration[8.0]
  def change
    drop_table :event_tasks
  end
end

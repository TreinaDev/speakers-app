class ChangeEventTaskContentColumnName < ActiveRecord::Migration[8.0]
  def change
    rename_column :event_task_contents, :event_contents_id, :event_content_id
    rename_column :event_task_contents, :event_tasks_id, :event_task_id
  end
end

class CreateEventTaskContents < ActiveRecord::Migration[8.0]
  def change
    create_table :event_task_contents do |t|
      t.references :event_contents, null: false, foreign_key: true
      t.references :event_tasks, null: false, foreign_key: true

      t.timestamps
    end
  end
end

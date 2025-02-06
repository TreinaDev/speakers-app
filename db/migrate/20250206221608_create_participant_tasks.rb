class CreateParticipantTasks < ActiveRecord::Migration[8.0]
  def change
    create_table :participant_tasks do |t|
      t.references :participant_record, null: false, foreign_key: true
      t.references :curriculum_task, null: false, foreign_key: true
      t.boolean :task_status

      t.timestamps
    end
  end
end

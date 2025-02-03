class CreateCurriculumTaskContents < ActiveRecord::Migration[8.0]
  def change
    create_table :curriculum_task_contents do |t|
      t.references :curriculum_task, null: false, foreign_key: true
      t.references :curriculum_content, null: false, foreign_key: true

      t.timestamps
    end
  end
end

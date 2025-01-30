class CreateCurriculumTasks < ActiveRecord::Migration[8.0]
  def change
    create_table :curriculum_tasks do |t|
      t.references :curriculum, null: false, foreign_key: true
      t.string :title
      t.text :description
      t.integer :certificate_requirement, default: 0

      t.timestamps
    end
  end
end

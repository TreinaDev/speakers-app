class AddCodeToCurriculumTask < ActiveRecord::Migration[8.0]
  def change
    add_column :curriculum_tasks, :code, :string
    add_index :curriculum_tasks, :code, unique: true
  end
end

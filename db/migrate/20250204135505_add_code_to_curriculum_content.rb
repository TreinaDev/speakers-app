class AddCodeToCurriculumContent < ActiveRecord::Migration[8.0]
  def change
    add_column :curriculum_contents, :code, :string
    add_index :curriculum_contents, :code, unique: true
  end
end

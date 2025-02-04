class AddCodeToCurriculum < ActiveRecord::Migration[8.0]
  def change
    add_column :curriculums, :code, :string
    add_index :curriculums, :code, unique: true
  end
end

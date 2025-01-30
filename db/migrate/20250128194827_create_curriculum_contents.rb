class CreateCurriculumContents < ActiveRecord::Migration[8.0]
  def change
    create_table :curriculum_contents do |t|
      t.references :curriculum, null: false, foreign_key: true
      t.references :event_content, null: false, foreign_key: true

      t.timestamps
    end
  end
end

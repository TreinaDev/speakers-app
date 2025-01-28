class CreateCurriculums < ActiveRecord::Migration[8.0]
  def change
    create_table :curriculums do |t|
      t.references :user, null: false, foreign_key: true
      t.string :schedule_item_code

      t.timestamps
    end
  end
end

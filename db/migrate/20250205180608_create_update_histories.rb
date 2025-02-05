class CreateUpdateHistories < ActiveRecord::Migration[8.0]
  def change
    create_table :update_histories do |t|
      t.references :event_content, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.text :description
      t.datetime :creation_date

      t.timestamps
    end
  end
end

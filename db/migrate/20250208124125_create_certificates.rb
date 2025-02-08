class CreateCertificates < ActiveRecord::Migration[8.0]
  def change
    create_table :certificates do |t|
      t.string :responsable_name, null: false
      t.string :speaker_code, null: false
      t.string :schedule_item_name, null: false
      t.string :event_name, null: false
      t.date :date_of_occurrence, null: false
      t.date :issue_date, null: false
      t.integer :length, null: false
      t.string :token, null: false
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end

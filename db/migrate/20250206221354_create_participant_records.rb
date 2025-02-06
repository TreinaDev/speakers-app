class CreateParticipantRecords < ActiveRecord::Migration[8.0]
  def change
    create_table :participant_records do |t|
      t.string :participant_code
      t.references :user, null: false, foreign_key: true
      t.string :schedule_item_code
      t.boolean :enabled_certificate

      t.timestamps
    end
  end
end

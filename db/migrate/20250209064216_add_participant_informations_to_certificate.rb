class AddParticipantInformationsToCertificate < ActiveRecord::Migration[8.0]
  def change
    add_column :certificates, :participant_name, :string, null: false
    add_column :certificates, :participant_register, :string, null: false
  end
end

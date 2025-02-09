class AddParticipantCodeToCertificate < ActiveRecord::Migration[8.0]
  def change
    add_column :certificates, :participant_code, :string, null: false
  end
end

class AddScheculeItemCodeToCertificate < ActiveRecord::Migration[8.0]
  def change
    add_column :certificates, :schedule_item_code, :string, null: false
  end
end

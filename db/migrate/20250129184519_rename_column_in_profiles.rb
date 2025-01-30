class RenameColumnInProfiles < ActiveRecord::Migration[8.0]
  def change
    rename_column :profiles, :gender_private, :display_gender
    rename_column :profiles, :pronoun_private, :display_pronoun
    rename_column :profiles, :city_private, :display_city
    rename_column :profiles, :birth_private, :display_birth
  end
end

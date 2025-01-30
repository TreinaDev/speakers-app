class AddGenderPronounCityAndBirthPrivateInProfile < ActiveRecord::Migration[8.0]
  def change
    add_column :profiles, :gender_private, :boolean, default: true
    add_column :profiles, :pronoun_private, :boolean, default: true
    add_column :profiles, :city_private, :boolean, default: true
    add_column :profiles, :birth_private, :boolean, default: true
  end
end

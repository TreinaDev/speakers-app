class AddPronounGenderCityBirthToProfile < ActiveRecord::Migration[8.0]
  def change
    add_column :profiles, :pronoun, :string
    add_column :profiles, :gender, :string
    add_column :profiles, :city, :string
    add_column :profiles, :birth, :date
  end
end

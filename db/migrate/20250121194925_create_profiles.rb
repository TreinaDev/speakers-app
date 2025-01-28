class CreateProfiles < ActiveRecord::Migration[8.0]
  def change
    create_table :profiles do |t|
      t.string :title
      t.text :about_me
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end

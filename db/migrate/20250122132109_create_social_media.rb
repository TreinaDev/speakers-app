class CreateSocialMedia < ActiveRecord::Migration[8.0]
  def change
    create_table :social_media do |t|
      t.string :url
      t.integer :social_media_type
      t.references :profile, null: false, foreign_key: true

      t.timestamps
    end
  end
end

class RenameSocialMediaToSocialNetwork < ActiveRecord::Migration[8.0]
  def change
    rename_column :social_media, :social_media_type, :social_network_type
    rename_table :social_media, :social_network
  end
end

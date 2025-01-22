class RenameSocialNetowrkToPlural < ActiveRecord::Migration[8.0]
  def change
    rename_table :social_network, :social_networks
  end
end

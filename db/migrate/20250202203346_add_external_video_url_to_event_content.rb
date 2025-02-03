class AddExternalVideoUrlToEventContent < ActiveRecord::Migration[8.0]
  def change
    add_column :event_contents, :external_video_url, :string
  end
end

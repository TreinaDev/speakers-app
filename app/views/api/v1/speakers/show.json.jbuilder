if @speaker.present?
  json.speaker do
    json.first_name @speaker.first_name
    json.last_name @speaker.last_name
    json.role @speaker.profile.title
    json.profile_image_url rails_blob_url(@speaker.profile.profile_picture, host: request.base_url)
    json.profile_url profile_url(@speaker.profile.username)
  end
end

json.curriculum do
  if @curriculum.curriculum_contents.any?
    json.curriculum_contents @curriculum.curriculum_contents do |content|
      json.title content.event_content.title
      json.description content.event_content.description.body
      json.external_video_url content.event_content.external_video_url
      if content.event_content.files.attached?
        json.files content.event_content.files do |file|
          json.filename file.filename
          json.file_download_url rails_blob_url(file, only_path: true)
        end
      end
    end
  end

  if  @curriculum.curriculum_tasks.any?
    json.curriculum_tasks @curriculum.curriculum_tasks do |task|
      json.title task.title
      json.description task.description
      json.certificate_requirement task.certificate_requirement
    end
  end
end

if @curriculum.present?
  json.curriculum do
    if @curriculum.curriculum_contents.any?
      json.curriculum_contents @curriculum.curriculum_contents do |content|
        json.code content.event_content.code
        json.title content.event_content.title
        json.description content.event_content.description.body
        if content.event_content.external_video_url.present?
          json.external_video_url render_external_video(content.event_content.external_video_url)
        end
        if content.event_content.files.attached?
          json.files content.event_content.files do |file|
            json.filename file.filename
            json.file_download_url rails_blob_url(file)
          end
        end
      end
    end
    json.tasks_available @tasks_available
    if  @curriculum.curriculum_tasks.any?
      json.curriculum_tasks @curriculum.curriculum_tasks do |task|
        json.code task.code
        json.title task.title
        json.description task.description
        json.certificate_requirement task.translated_certificate_requirement(task.certificate_requirement)
        if task.curriculum_contents.any?
          json.attached_contents task.curriculum_contents do |content|
            json.attached_content_code content.event_content.code
          end
        end
      end
    end
  end
end

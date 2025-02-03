module ApplicationHelper
  def go_back_button(path)
    link_to path, class: 'flex border-2 rounded-3xl p-3 mb-3 w-32' do
      image_tag('arrow_back_icon.png', class: 'icon') +
      content_tag(:span, 'VOLTAR', class: 'text-[#6e487c]')
    end
  end

  def render_external_video(url)
    if url.include?('youtube.com')
      video_code = url.split('=').last
      "<iframe id='external-video' width='800' height='450' src='https://www.youtube.com/embed/#{video_code}' frameborder='0' allowfullscreen></iframe>".html_safe
    elsif url.include?('vimeo.com')
      video_code = url.split('/').last
      "<iframe id='external-video' width='800' height='450' src='https://player.vimeo.com/video/#{video_code}' frameborder='0' allowfullscreen></iframe>".html_safe
    end
  end
end

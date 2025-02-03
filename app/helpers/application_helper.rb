module ApplicationHelper
  def go_back_button(path)
    link_to path, class: 'flex border-2 rounded-3xl p-3 mb-3 w-32  items-center gap-x-2' do
      image_tag('arrow_back_icon.png', class: 'icon') +
      content_tag(:span, 'VOLTAR', class: 'text-[#6e487c]')
    end
  end
end

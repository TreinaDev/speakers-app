require 'rails_helper'

describe ApplicationHelper, type: :helper do
  context '#go_back_button' do
    it 'must return correct link' do
      expect(helper.go_back_button('/home')).to include "href=\"/home\""
    end
  end

  context '#render_external_video' do
    it 'must return corret iframe with youtube video' do
      expect(helper.render_external_video('https://www.youtube.com/watch?v=PbxBtQH5R_o')).to eq "<iframe id='external-video' width='800' height='450' src='https://www.youtube.com/embed/PbxBtQH5R_o' frameborder='0' allowfullscreen></iframe>"
    end

    it 'must return corret iframe with vimeo video' do
      expect(helper.render_external_video('https://vimeo.com/1047790821')).to eq "<iframe id='external-video' width='800' height='450' src='https://player.vimeo.com/video/1047790821' frameborder='0' allowfullscreen></iframe>"
    end
  end
end

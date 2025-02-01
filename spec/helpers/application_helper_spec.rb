require 'rails_helper'

describe ApplicationHelper, type: :helper do
  context '#go_back_button' do
    it 'must return correct link' do
      expect(helper.go_back_button('/home')).to include "href=\"/home\""
    end
  end
end

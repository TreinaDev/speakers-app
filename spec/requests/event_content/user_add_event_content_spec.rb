require 'rails_helper'

describe 'user add event content', type: :request  do
  it 'must be authenticated' do
    params = { title: 'Ruby para iniciantes', description: 'Um guia para programadores felizes.' }
    expect { post(event_contents_path, params: { event_content: params }) }.to change(EventContent, :count).by(0)
  end

  it 'with success' do
    user = create(:user)
    create(:profile, user: user)

    login_as user

    params = { title: 'Ruby para iniciantes', description: 'Um guia para programadores felizes.' }
    expect { post(event_contents_path, params: { event_content: params }) }.to change(EventContent, :count).by(1)
  end
end

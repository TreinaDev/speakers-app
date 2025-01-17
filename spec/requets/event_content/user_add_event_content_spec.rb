require 'rails_helper'

describe 'user add event content', type: :request  do
  it 'must be authenticated' do
    params = { title: 'Ruby para iniciantes', description: 'Um guia para programadores felizes.' }
    expect { post(event_contents_path, params: params) }.to change(EventContent, :count).by(0)
  end
end

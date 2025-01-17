require 'rails_helper'

describe 'User view event content list', type: :request do
  it 'must be authenticate' do
    get(event_contents_path)

    expect(response).to redirect_to new_user_session_path
  end
end

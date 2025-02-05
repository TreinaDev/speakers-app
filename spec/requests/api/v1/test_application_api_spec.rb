require 'rails_helper'

describe 'Application API', type: :request do
  it 'and raise error if route does not exist' do
    route = '/api/v1/exemplo/teste'

    expect { get route }.to raise_error ActionController::RoutingError
  end
end

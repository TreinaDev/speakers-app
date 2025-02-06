require 'rails_helper'

RSpec.describe UpdateHistory, type: :model do
  context 'validations' do
    it { should belong_to(:user) }
    it { should belong_to(:event_content) }
    it { validate_presence_of(:creation_date) }
    it { validate_presence_of(:description) }
  end
end

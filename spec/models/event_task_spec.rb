require 'rails_helper'

RSpec.describe EventTask, type: :model do
  context 'validations' do
    it { validate_presence_of(:name) }
    it { validate_presence_of(:description) }
    it { validate_presence_of(:certificate_requirement) }
    it { should belong_to(:user) }
    it { should have_many(:event_task_contents) }
    it { should have_many(:event_contents) }
  end
end

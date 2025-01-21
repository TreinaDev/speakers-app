require 'rails_helper'

RSpec.describe EventTask, type: :model do
  context 'validations' do
    it { validate_presence_of(:name) }
    it { validate_presence_of(:description) }
    it { validate_presence_of(:certificate_requirement) }
    it { should belong_to(:user) }
    it { should have_many(:event_task_contents) }
    it { should have_many(:event_contents).through(:event_task_contents) }
    it { should accept_nested_attributes_for(:event_task_contents).allow_destroy(true) }
    it { should define_enum_for(:certificate_requirement).with_values(mandatory: 1, optional: 0) }
    it { should define_enum_for(:certificate_requirement).with_default(:optional) }
  end
end

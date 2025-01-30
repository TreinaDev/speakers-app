require 'rails_helper'

RSpec.describe CurriculumTask, type: :model do
  context 'validations' do
    it { validate_presence_of(:title) }
    it { validate_presence_of(:description) }
    it { validate_presence_of(:certificate_requirement) }
    it { should belong_to(:curriculum) }
    it { should define_enum_for(:certificate_requirement).with_values(mandatory: 1, optional: 0) }
    it { should define_enum_for(:certificate_requirement).with_default(:optional) }
  end
end

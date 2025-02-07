require 'rails_helper'

RSpec.describe ParticipantTask, type: :model do
  context 'validations' do
    it { should belong_to(:participant_record) }
    it { should belong_to(:curriculum_task) }
  end
end

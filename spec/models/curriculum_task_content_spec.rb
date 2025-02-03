require 'rails_helper'

RSpec.describe CurriculumTaskContent, type: :model do
  it { should belong_to(:curriculum_content) }
  it { should belong_to(:curriculum_task) }
end

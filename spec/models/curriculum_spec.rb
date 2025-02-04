require 'rails_helper'

RSpec.describe Curriculum, type: :model do
  it { should belong_to(:user) }
  it { validate_presence_of(:code) }
  it { validate_uniqueness_of(:code) }

  context '.to_param' do
    it 'must return the curriculum.code' do
      curriculum = create(:curriculum, code: 'ABCDE')

      expect(curriculum.to_param).to eq 'ABCDE'
    end
  end

  context '.generate_code' do
    it 'must return an unique code' do
      first_curriculum = create(:curriculum)
      second_curriculum = create(:curriculum)

      expect(first_curriculum.code).not_to eq second_curriculum.code
    end
  end
end

require 'rails_helper'

RSpec.describe Certificate, type: :model do
  context 'validations' do
    it { should belong_to(:user) }
    it { should validate_presence_of(:responsable_name) }
    it { should validate_presence_of(:speaker_code) }
    it { should validate_presence_of(:event_name) }
    it { should validate_presence_of(:date_of_occurrence) }
    it { should validate_presence_of(:issue_date) }
    it { should validate_presence_of(:length) }
    it { should validate_presence_of(:participant_code) }
    it { should validate_presence_of(:schedule_item_code) }
  end

  context '#valid?' do
    it 'token must uniqueness' do
      certificate = create(:certificate)
      token = certificate.token

      new_certificate = build(:certificate, token: token)

      expect(new_certificate).not_to be_valid
    end

    it 'token must be presence' do
      certificate = build(:certificate)
      certificate.token = ''

      expect(certificate).not_to be_valid
    end
  end

  context '.time_diff' do
    it 'should return the interval between two hours' do
      start_time = Time.new(2025, 2, 8, 10, 0, 0)
      end_time = Time.new(2025, 2, 8, 15, 0, 0)
      schedule = instance_double('schedule', start_time: start_time, end_time: end_time)

      expect(Certificate.time_diff(schedule)).to eq '5 horas e 0 minutos'
    end
  end
end

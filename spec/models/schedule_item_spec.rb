require 'rails_helper'

describe ScheduleItem do
  context '.find' do
    it 'should return a schedule item' do
      ScheduleItem.delete_all
      user = create(:user, email: 'joao@email.com')
      schedule_item_instance = build(:schedule_item, title: 'Entrevista com João', description: 'Aprenda sobre RoR e TDD', speaker_email: user.email, length: 100)
      allow(ScheduleItem).to receive(:find).and_return(schedule_item_instance)

      schedule_item = ScheduleItem.find(schedule_item_instance.id, user.email)

      expect(ScheduleItem.count).to eq 1
      expect(schedule_item.title).to eq 'Entrevista com João'
      expect(schedule_item.description).to eq 'Aprenda sobre RoR e TDD'
      expect(schedule_item.speaker_email).to eq 'joao@email.com'
      expect(schedule_item.length).to eq 100
    end

    it 'must return nil if not found schedule item' do
      ScheduleItem.delete_all
      allow(ScheduleItem).to receive(:find).and_return(nil)

      schedule_item = ScheduleItem.find(999999, 'something@email.com')

      expect(ScheduleItem.count).to eq 0
      expect(schedule_item).to be_nil
    end
  end

  context '.count' do
    it 'should return a count of all instances' do
      ScheduleItem.delete_all
      10.times do
        build(:schedule_item)
      end

      expect(ScheduleItem.count).to eq 10
    end

    it 'should return zero when no instances' do
      ScheduleItem.delete_all
      expect(ScheduleItem.count).to eq 0
    end
  end

  context '.delete_all' do
    it 'must delete all instances' do
      10.times do
        build(:schedule_item)
      end

      expect { ScheduleItem.delete_all }.to change(ScheduleItem, :count).by(-10)
    end
  end

  context '#participants' do
    it 'should return all list participants' do
      user = create(:user, email: 'joao@email.com')
      schedule_item = build(:schedule_item, title: 'Entrevista com João', description: 'Aprenda sobre RoR e TDD', speaker_email: user.email, length: 100)
      participants = []
      10.times do
        participants << build(:participant)
      end
      allow(schedule_item).to receive(:participants).and_return(participants)
      participants = schedule_item.participants

      expect(participants.count).to eq 10
    end

    it 'should return zero if not found participants' do
      user = create(:user, email: 'joao@email.com')
      schedule_item = build(:schedule_item, title: 'Entrevista com João', description: 'Aprenda sobre RoR e TDD', speaker_email: user.email, length: 100)
      allow(schedule_item).to receive(:participants).and_return([])
      participants = schedule_item.participants

      expect(participants.count).to eq 0
    end
  end
end

require 'rails_helper'

describe ScheduleItem do
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
end

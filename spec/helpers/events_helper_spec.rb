require 'rails_helper'

describe EventsHelper, type: :helper do
  context '.ongoing' do
    it 'should return true if event is ongoing' do
      event = build(:event, start_date: 1.day.ago, end_date: 1.day.from_now)

      expect(ongoing(event)).to eq true
    end

    it 'should return false if event not is ongoing' do
      event = build(:event, start_date: 1.day.from_now, end_date: 3.day.from_now)

      expect(ongoing(event)).to eq false
    end
  end

  context '.future_events' do
    it 'should return true if event is future' do
      event = build(:event, start_date: 1.day.from_now, end_date: 3.day.from_now)

      expect(future_events(event)).to eq true
    end

    it 'should return false if event not is future' do
      event = build(:event, start_date: 3.day.ago, end_date: 1.day.ago)

      expect(future_events(event)).to eq false
    end
  end

  context '.past_events' do
    it 'should return true if event is past' do
      event = build(:event, start_date: 3.day.ago, end_date: 1.day.ago)

      expect(past_events(event)).to eq true
    end

    it 'should return false if event not is past' do
      event = build(:event, start_date: 1.day.from_now, end_date: 3.day.from_now)

      expect(past_events(event)).to eq false
    end
  end
end

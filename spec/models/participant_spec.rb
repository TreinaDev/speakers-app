require 'rails_helper'

describe Participant do
  context '.find' do
    it 'should return a participant' do
      participant = build(:participant, code: 'ABC123')
      allow(Participant).to receive(:find).and_return(participant)

      result = Participant.find(participant_code: 'ABC123')

      expect(result).to eq participant
    end

    it 'should return nil if not found' do
      allow(Participant).to receive(:find).and_return(nil)

      result = Participant.find(participant_code: 'ABC123')

      expect(result).to be_nil
    end
  end

  context '.full_name' do
    it 'should return a full name' do
      firt_name = 'João'
      last_name = 'Campus'

      full_name = Participant.full_name(firt_name, last_name)

      expect(full_name).to eq 'João Campus'
    end
  end
end
require 'rails_helper'

describe Feedback do
  context '.event' do
    it 'must return all feedbacks the Event' do
      user = create(:user, first_name: 'User1', last_name: 'LastName1', email: 'joao@email.com', password: '123456')
      event = build(:event, name: 'Ruby on Rails')
      event_feedbacks = [ build(:feedback, user: 'João', title: 'Muito bom!', comment: 'Gostei muito'),
                         build(:feedback, user: 'Anônimo', title: 'Podia ser melhor', comment: 'Faltou café'),
                         build(:feedback, user: 'Joaquim', title: 'Parabéns você foi selecionado', comment: 'Esta mensagem foi marcada como Spam') ]
      allow(ExternalParticipantApi::GetEventFeedbacksService).to receive(:call).and_return(event_feedbacks)

      feedbacks = Feedback.event(event_code: event.code, speaker: user.email)

      expect(feedbacks.count).to eq 3
      expect(feedbacks[0].user).to eq 'João'
      expect(feedbacks[0].title).to eq 'Muito bom!'
      expect(feedbacks[0].comment).to eq 'Gostei muito'
      expect(feedbacks[1].user).to eq 'Anônimo'
      expect(feedbacks[1].title).to eq 'Podia ser melhor'
      expect(feedbacks[1].comment).to eq 'Faltou café'
      expect(feedbacks[2].user).to eq 'Joaquim'
      expect(feedbacks[2].title).to eq 'Parabéns você foi selecionado'
      expect(feedbacks[2].comment).to eq 'Esta mensagem foi marcada como Spam'
    end

    it 'must return zero if not found Feedbacks' do
      user = create(:user, first_name: 'User1', last_name: 'LastName1', email: 'joao@email.com', password: '123456')
      event = build(:event, name: 'Ruby on Rails')
      allow(ExternalParticipantApi::GetEventFeedbacksService).to receive(:call).and_return([])

      feedbacks = Feedback.event(event_code: event.code, speaker: user.email)

      expect(feedbacks.count).to eq 0
    end
  end
end

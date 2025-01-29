require 'rails_helper'

describe Feedback do
  context '.event' do
    it 'must return all feedbacks the Event' do
      user = create(:user, first_name: 'User1', last_name: 'LastName1', email: 'joao@email.com', password: '123456')
      event = build(:event, name: 'Ruby on Rails', description: 'Introdução ao Rails com TDD',
              start_date: 7.days.from_now, end_date: 14.days.from_now, url: 'www.meuevento.com/eventos/Ruby-on-Rails',
              event_type: 'Presencial', location: 'Juiz de Fora', participant_limit: 100, status: 'Publicado')
      event_feedbacks = [build(:feedback, name: 'João', title: 'Muito bom!', description: 'Gostei muito'),
                         build(:feedback, name: 'Anônimo', title: 'Podia ser melhor', description: 'Faltou café'),
                         build(:feedback, name: 'Joaquim', title: 'Parabéns você foi selecionado', description: 'Esta mensagem foi marcada como Spam')]
      allow(ExternalParticipantApi::GetEventFeedbacksService).to receive(:call).and_return(event_feedbacks)

      feedbacks = Feedback.event(event_id: event.id, speaker: user.email)

      expect(feedbacks.count).to eq 3
      expect(feedbacks[0].name).to eq 'João'
      expect(feedbacks[0].title).to eq 'Muito bom!'
      expect(feedbacks[0].description).to eq 'Gostei muito'
      expect(feedbacks[1].name).to eq 'Anônimo'
      expect(feedbacks[1].title).to eq 'Podia ser melhor'
      expect(feedbacks[1].description).to eq 'Faltou café'
      expect(feedbacks[2].name).to eq 'Joaquim'
      expect(feedbacks[2].title).to eq 'Parabéns você foi selecionado'
      expect(feedbacks[2].description).to eq 'Esta mensagem foi marcada como Spam'
    end

    it 'must return zero if not found Feedbacks' do
      user = create(:user, first_name: 'User1', last_name: 'LastName1', email: 'joao@email.com', password: '123456')
      event = build(:event, name: 'Ruby on Rails', description: 'Introdução ao Rails com TDD',
              start_date: 7.days.from_now, end_date: 14.days.from_now, url: 'www.meuevento.com/eventos/Ruby-on-Rails',
              event_type: 'Presencial', location: 'Juiz de Fora', participant_limit: 100, status: 'Publicado')
      allow(ExternalParticipantApi::GetEventFeedbacksService).to receive(:call).and_return([])

      feedbacks = Feedback.event(event_id: event.id, speaker: user.email)

      expect(feedbacks.count).to eq 0
    end
  end
end

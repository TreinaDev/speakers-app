require 'rails_helper'

describe FeedbackScheduleItem do
  context '.schedule' do
    it 'must return all feedbacks this schedule item' do
      FeedbackScheduleItem.delete_all
      user = create(:user, first_name: 'User1', last_name: 'LastName1', email: 'joao@email.com', password: '123456')
      schedule_item_instance = build(:schedule_item, name: 'Entrevista com João', description: 'Aprenda sobre RoR e TDD',
                                      responsible_email: user.email, start_time: '11:00', end_time: '12:00', code: 'ABCD1234')

      schedule_item_feedback = build(:feedback_schedule_item, title: 'Entrevista', comment: 'Aprendi muito',
                                      mark: 5, user: user, schedule_item_id: schedule_item_instance.code)

      allow(ExternalParticipantApi::GetScheduleItemFeedbacksService).to receive(:call).and_return(schedule_item_feedback)
      schedule_item_feedbacks = FeedbackScheduleItem.schedule(schedule_item_code: schedule_item_feedback.schedule_item_id)

      expect(FeedbackScheduleItem.count).to eq 1
      expect(schedule_item_feedbacks.comment).to eq 'Aprendi muito'
      expect(schedule_item_feedbacks.title).to eq 'Entrevista'
      expect(schedule_item_feedbacks.mark).to eq 5
      expect(schedule_item_feedbacks.schedule_item_id).to eq 'ABCD1234'
    end

    it 'must return zero if not found Schedule Item Feedbacks' do
      user = create(:user, first_name: 'User1', last_name: 'LastName1', email: 'joao@email.com', password: '123456')
      event = build(:event, name: 'Ruby on Rails')
      schedule_item_instance = build(:schedule_item, name: 'Entrevista com João', description: 'Aprenda sobre RoR e TDD',
      responsible_email: user.email, start_time: '11:00', end_time: '12:00', code: 'ABCD1234')
      allow(ExternalParticipantApi::GetScheduleItemFeedbacksService).to receive(:call).and_return([])

      schedule_item_feedbacks = FeedbackScheduleItem.schedule(schedule_item_code: schedule_item_instance.code)

      expect(schedule_item_feedbacks.count).to eq 0
    end
  end

  context '.count' do
    it 'should return a count of all instances' do
      FeedbackScheduleItem.delete_all
      10.times do
        build(:feedback_schedule_item)
      end

      expect(FeedbackScheduleItem.count).to eq 10
    end

    it 'should return zero when no instances' do
      FeedbackScheduleItem.delete_all
      expect(FeedbackScheduleItem.count).to eq 0
    end
  end

  context '.delete_all' do
    it 'must delete all instances' do
      10.times do
        build(:feedback_schedule_item)
      end

      expect { FeedbackScheduleItem.delete_all }.to change(FeedbackScheduleItem, :count).by(-10)
    end
  end
end

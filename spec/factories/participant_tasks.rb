FactoryBot.define do
  factory :participant_task do
    participant_record { nil }
    curriculum_task { nil }
    task_status { false }
  end
end

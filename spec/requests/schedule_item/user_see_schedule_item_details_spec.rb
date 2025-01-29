require 'rails_helper'

describe 'User see schedule item details', type: :request do
  it 'must be authenticated' do
    get schedule_item_path(1)

    expect(response).to redirect_to new_user_session_path
    expect(flash[:alert]).to eq "Para continuar, faça login ou registre-se."
  end

  it 'must redirect to events_path when schedule item not found' do
    user = create(:user)

    login_as user, scope: :user
    get schedule_item_path(9999999)

    expect(response).to redirect_to events_path
    expect(flash[:alert]).to eq 'Essa Programação não existe'
  end

  it 'must be same speaker email' do
    ScheduleItem.delete_all
    first_user = create(:user, email: 'joao@email.com')
    first_schedule_item = build(:schedule_item, speaker_email: first_user.email)
    other_user = create(:user, email: 'other@email.com')

    login_as other_user, scope: :user
    get schedule_item_path(first_schedule_item.id)

    expect(response).to redirect_to events_path
    expect(flash[:alert]).to eq 'Essa Programação não existe'
  end
end

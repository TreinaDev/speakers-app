class Api::V1::CurriculumsController < Api::V1::ApiController
  helper ApplicationHelper
  def show
    @curriculum = Curriculum.find_by(schedule_item_code: params[:schedule_item_code])
    schedule_item = ScheduleItem.find(schedule_item_code: params[:schedule_item_code], token: @curriculum.user.token)
    @tasks_available = Date.today >= schedule_item.event.start_date
    render status: :not_found, json: { error: I18n.t('not_found_error', model: Curriculum.model_name.human) } if @curriculum.nil?
  end
end

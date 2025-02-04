class Api::V1::CurriculumsController < Api::V1::ApiController
  def show
    @curriculum = Curriculum.find_by(schedule_item_code: params[:schedule_item_code])

    render status: :not_found, json: { error: I18n.t('not_found_error', model: Curriculum.model_name.human) } if @curriculum.nil?
  end
end

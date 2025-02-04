class Api::V1::CurriculumsController < Api::V1::ApiController
  def show
    @curriculum = Curriculum.find_by(schedule_item_code: params[:schedule_item_id])
  end
end

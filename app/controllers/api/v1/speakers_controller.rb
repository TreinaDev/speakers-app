class Api::V1::SpeakersController < Api::V1::ApiController
  def show
    @speaker = User.find_by(email: params[:email].to_s)

    render status: :not_found, json: { error: I18n.t('not_found_error', model: User.model_name.human) } if @speaker.nil?
  end
end

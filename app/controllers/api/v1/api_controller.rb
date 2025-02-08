class Api::V1::ApiController < ActionController::API
  rescue_from ActiveRecord::ActiveRecordError, with: :internal_server_error
  rescue_from ActiveRecord::RecordNotFound, with: :not_found

  def internal_server_error
    render status: 500, json: { error: I18n.t('internal_server_error') }
  end

  def not_found
    render :not_found, json: { error:  I18n.t('generic_not_found') }
  end
end

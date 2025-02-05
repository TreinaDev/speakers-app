class Api::V1::ApiController < ActionController::API
  rescue_from ActiveRecord::ActiveRecordError, with: :internal_server_error
  rescue_from ActiveRecord::RecordNotFound, with: :not_found

  def internal_server_error
    render status: 500, json: { error: 'Algo deu errado.' }
  end

  def not_found
    render :not_found, json: { error: 'Recurso não encontrado' }
  end
end

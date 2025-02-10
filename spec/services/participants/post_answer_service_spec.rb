require 'rails_helper'

describe ExternalParticipantApi::PostAnswerService do
  context '#call' do
  it 'when Api return success' do
    response = instance_double(Faraday::Response, success?: true)
    allow_any_instance_of(Faraday::Connection).to receive(:post).and_return(response)

    service = ExternalParticipantApi::PostAnswerService.new(feedback_id: 1, name: 'Thiago Gois', email: 'thiago@email.com', answer: 'Muito legal o seu comentário')
    response = service.call

    expect(response).to eq(true)
  end

  it 'when Api return error' do
    response = instance_double(Faraday::Response, success?: false)
    allow_any_instance_of(Faraday::Connection).to receive(:post).and_return(response)

    service = ExternalParticipantApi::PostAnswerService.new(feedback_id: 1, name: 'Thiago Gois', email: 'thiago@email.com', answer: 'Muito legal o seu comentário')
    response = service.call

    expect(response).to eq(false)
  end

  it 'when Connection Failed exception happens' do
    logger = Rails.logger
    allow_any_instance_of(Faraday::Connection).to receive(:post).and_raise(Faraday::ConnectionFailed)
    allow(logger).to receive(:error)
    service = ExternalParticipantApi::PostAnswerService.new(schedule_item_id: 1)

    service.call

    expect(logger).to have_received(:error).with(Faraday::ConnectionFailed)
  end
  end
end

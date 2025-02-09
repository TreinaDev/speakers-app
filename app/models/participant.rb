class Participant
  extend ActiveModel::Translation
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :name, :string
  attribute :last_name, :string
  attribute :email, :string
  attribute :cpf, :string
  attribute :code, :string

  def initialize(**params)
    super(participant_permitted_params(params))
  end

  def self.find(participant_code:)
    ExternalParticipantApi::GetParticipantDetailsService.call(participant_code: participant_code)
  end

  private

  def participant_permitted_params(params)
    ActionController::Parameters.new(params).permit(Participant.attribute_names)
  end
end

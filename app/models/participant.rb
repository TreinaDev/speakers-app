class Participant
  extend ActiveModel::Translation
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :name, :string
  attribute :last_name, :string
  attribute :email, :string
  attribute :cpf, :string

  def initialize(**params)
    super(participant_permited_params(params))
  end

  private

  def participant_permited_params(params)
    ActionController::Parameters.new(params).permit(Participant.attribute_names)
  end
end

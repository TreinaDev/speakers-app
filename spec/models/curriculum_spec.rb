require 'rails_helper'

RSpec.describe Curriculum, type: :model do
  it { should belong_to(:user) }
end

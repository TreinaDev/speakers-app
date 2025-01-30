require 'rails_helper'

describe ApplicationService do
  context '#call' do
    it 'must return an exception if not implemented method' do
      expect { subject.call }.to raise_error(NotImplementedError, "method 'call' not implemented")
    end

    it 'not implemented method call' do
      described_class.class_eval { def call; 'Something' end }

      expect { subject.call }.not_to raise_error
    end
  end
end

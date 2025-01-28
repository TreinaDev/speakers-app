class ApplicationService
  def initialize(**kwargs)
    @kwargs = kwargs
  end

  def self.call(**kwargs)
    new(**kwargs).call
  end

  def call
    raise NotImplementedError, "method 'call' not implemented"
  end

  private

  attr_reader :kwargs
end

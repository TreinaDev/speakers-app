class ApplicationModel
  extend ActiveModel::Translation

  def self.find_instance(instances, id)
    instances.find { |instance| instance.id == id.to_i }
  end
end
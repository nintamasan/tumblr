class Part
  class << self
    def attributes
      %w[ name url embed_url tag ]
    end
  end

  attr_accessor *self.attributes

  def initialize(info)
    self.class.attributes.each do |attr|
      self.instance_variable_set(:"@#{attr}", info[attr])
    end
  end
end

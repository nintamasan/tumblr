class Image
  class << self
    def attributes
      %w[ id title url tags ]
    end
  end

  attr_accessor *self.attributes

  def initialize(info)
    self.class.attributes.each do |attr|
      self.instance_variable_set(:"@#{attr}", info[attr])
    end

    if self.tags
      self.tags = self.tags.dup # to avoid corruption
    else
      self.tags ||= []
    end
  end

  def tumblr_param
    { caption: title,
      source:  url,
      tags:    tags,
    }
  end
end

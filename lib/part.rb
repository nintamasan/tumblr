require "facets/string/camelcase"

class Part
  class << self
    def attributes
      %w[ id title name type movie_id url embed tags ]
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

    acts_as(type) if type
  end

  def acts_as(type)
    require_relative "plugins/#{type}"
    extend Plugin.const_get(type.camelcase(true))
  end

  def full_name
    [ title, name ].join(" ")
  end

  def caption
    if url
      "[#{full_name}](#{url})"
    else
      full_name
    end
  end

  def tumblr_param
    { caption: caption,
      format:  "markdown",
      embed:   embed,
      tags:    tags,
    }
  end
end

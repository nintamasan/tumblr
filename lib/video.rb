require "yaml"

require_relative "part"
require_relative "image"

class Video
  class << self
    def load(config_file)
      video = self.new
      video.config_file = config_file
      video
    end

    def config_path(id)
      "videos/#{id}#{config_suffix}"
    end

    def config_suffix
      ".yaml"
    end

    def video_configs
      Dir[config_path("*")].sort.map {|config| Video.load(config) }
    end

    def ids
      video_configs.map(&:id)
    end
  end

  def initialize(id = nil)
    if id
      @config_file = Pathname.new(self.class.config_path(id))
    end
  end

  def inspect
    [ "#{id}: #{title}",
      parts.map {|part| "  #{part.url} #{part.name} (#{part.tags.join(",")})" },
    ].join("\n")
  end

  def id
    @config_file.basename(self.class.config_suffix).to_s
  end

  def config_file=(config_file)
    @config_file = Pathname.new(config_file)
  end

  def title
    config["title"]
  end

  def image
    unless @image
      @image = Image.new(config["image"].merge("title" => title))
      @image.tags.push(id)
    end
    @image
  end

  def parts
    unless @parts
      @parts = config["parts"].map {|part| Part.new(part.merge("title" => title)) }
      @parts.each {|part| part.tags.push(id) }

      unless @parts.all? {|part| part.name }
        # title is completed as n/m
        @parts.each.with_index {|part, i| part.name = "#{i.next}/#{parts.size}" }
      end
    end

    @parts
  end

  def update_info!
    config = Marshal.load(Marshal.dump(self.config))

    config["parts"].zip(parts).each do |original, part|
      original["id"] = part.id
    end

    config["image"]["id"] = image.id

    File.open(@config_file, "w") do |file|
      file << config.to_yaml
    end
  end

  protected
  def config
    @config ||= YAML.load_file(@config_file)
  end
end

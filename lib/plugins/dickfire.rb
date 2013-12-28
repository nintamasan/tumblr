# -*- coding: utf-8 -*-
module Plugin
  module Dickfire
    def url
      "http://www.dickfire.com/video/#{movie_id}"
    end

    def embed
      "<iframe src='http://www.dickfire.com/video_embed.php?vid=#{movie_id}'/>"
    end
  end
end

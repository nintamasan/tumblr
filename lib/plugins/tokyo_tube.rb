# -*- coding: utf-8 -*-
module Plugin
  module TokyoTube
    def url
      "http://www.tokyo-tube.com/video/#{movie_id}"
    end

    def embed
      <<-_SCRIPT_
<embed width="452" height="361" quality="high" wmode="transparent" name="main" id="main" allowfullscreen="true" allowscriptaccess="always" src="http://www.tokyo-tube.com/media/player/player.swf?f=http://www.tokyo-tube.com/media/player/config_embed.php?vkey=#{movie_id}" type="application/x-shockwave-flash" />
     _SCRIPT_
    end
  end
end

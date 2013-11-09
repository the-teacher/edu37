class String
  # SLIDESHARE ===================================================================
  # http://www.slideshare.net/slideshow/embed_code/8143636
  # http://static.slidesharecdn.com/swf/ssplayer2.swf?doc=random-110531120741-phpapp01&amp;stripped_title=ss-8163521&amp;userName=zykin-ilya

  def slideshare_player_code(slide_code)
    width = 480
    height = 360

    player_code = <<-PLAYER
    <notextile>
    <div class="slideshare_block">
      <iframe src="http://www.slideshare.net/slideshow/embed_code/#{slide_code}"
        width="#{width}" height="#{height}"
        frameborder="0" marginwidth="0" marginheight="0" scrolling="no"
      ></iframe>
    </div>
    </notextile>
    PLAYER

    "\n"+player_code.gsub("\n", '').gsub(/ {2,}/, '') # player to line
  end

  def slideshare_player_for_static(url)
    width = 480
    height = 360

    player_code = <<-PLAYER
    <notextile>
    <div class="slideshare_block">
      <object width="#{width}" height="#{height}">
        <param name="movie" value="#{url}" />
        <param name="allowFullScreen" value="true"/>
        <param name="allowScriptAccess" value="always"/>
        <embed  src="#{url}"
        type="application/x-shockwave-flash" allowscriptaccess="always" allowfullscreen="true" width="#{width}" height="#{height}"></embed>
      </object>
    </div>
    </notextile>
    PLAYER

    "\n"+player_code.gsub("\n", '').gsub(/ {2,}/, '') # player to line
  end

  def slideshare_links_to_players
    slideshare_1 = "(http://static.slidesharecdn.com/swf/ssplayer2.swf?[a-zA-Z0-9?&=-_;]*)(\s|<)"
    slideshare_2 = "(http://www.slideshare.net/slideshow/embed_code/([0-9]*))"
    str = self.dup
    # URL type 1
    str.scan(/#{slideshare_1}/mix).each do |match|
      url = match.first
      str.gsub!(url, slideshare_player_for_static(url))
    end
    # URL type 2
    str.scan(/#{slideshare_2}/mix).each do |match|
      slideshare_url = match.first
      slide_code = match.last
      str.gsub!(slideshare_url, slideshare_player_code(slide_code))
    end#self.scan
    str
  end

end

class String
  # VIMEO.COM ===================================================================
  # http://vimeo.com/12345678
  # http://player.vimeo.com/video/24452119?title=0&amp;byline=0&amp;portrait=0

  def vimeo_player_code(video_code)
    width = 480
    height = 360

    player_code = <<-PLAYER
    <div class="vimeo_block">
      <iframe src="http://player.vimeo.com/video/#{video_code}" width="#{width}" height="#{height}" frameborder="0"></iframe>
    </div>
    PLAYER

    "\n"+player_code.gsub("\n", '').gsub(/ {2,}/, '') # player to line
  end

  def vimeo_links_to_players
    vimeo_1 = "http://vimeo.com/[a-zA-Z0-9?&=-_;]*"
    video_code_1 = "http://vimeo.com/([a-zA-Z0-9?&=-_;]*)"

    vimeo_2 = "http://player.vimeo.com/video/[a-zA-Z0-9?&=-_;]*"
    video_code_2 = "http://player.vimeo.com/video/([a-zA-Z0-9?&=-_;]*)"

    str = self.dup
    str.scan(/#{vimeo_1}|#{vimeo_2}/mix).each do |match|
      match.each do |vimeo_url|
        # URL type 1
        vimeo_url.scan(/#{video_code_1}/mix).each do |match|
          video_code = match.first
          str.gsub!(vimeo_url, vimeo_player_code(video_code))
        end#vimeo_url.scan
        # URL type 2
        vimeo_url.scan(/#{video_code_2}/mix).each do |match|
          video_code = match.first
          str.gsub!(vimeo_url, vimeo_player_code(video_code))
        end#vimeo_url.scan
      end#match.each
    end#str.scan
    str
  end

end

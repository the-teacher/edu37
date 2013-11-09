class String
  # YOUTUBE.COM ===================================================================
  # TODO: <iframe width="560" height="349" src="http://www.youtube.com/embed/fHI7SDx63Ds" frameborder="0" allowfullscreen></iframe>

  def youtube_player_code(video_code)
    width = 480
    height = 360

    player_code = <<-PLAYER
    <notextile>
      <div class="youtube_block">
        <object width="#{width}" height="#{height}">
          <param name="movie" value="http://www.youtube.com/v/#{video_code}&hl=ru_RU&feature=player_embedded&version=3"></param>
          <param name="allowFullScreen" value="true"></param>
          <param name="allowScriptAccess" value="always"></param>
          <embed src="http://www.youtube.com/v/#{video_code}&hl=ru_RU&feature=player_embedded&version=3"
            type="application/x-shockwave-flash" allowfullscreen="true" allowScriptAccess="always" width="#{width}" height="#{height}"></embed>
        </object>
      </div>
    </notextile>
    PLAYER

    "\n"+player_code.gsub("\n", '').gsub(/ {2,}/, '') # player to line
  end

  def youtube_links_to_players
    youtube_1 = "http://www.youtube.com/[a-zA-Z0-9?=&-_/]*"
    youtube_code_1 = "http://www.youtube.com/watch?v=([a-zA-Z0-9-]*)?"

    youtube_2 = "http://www.youtube.com/v/[a-zA-Z0-9?=&-_/]*"
    youtube_code_2 = "http://www.youtube.com/v/([a-zA-Z0-9-]*)?"

    str = self.dup
    str.scan(/#{youtube_1}|#{youtube_2}/mix).each do |match|
      match.each do |youtube_url|
        # URL type 1
        youtube_url.scan(/#{youtube_code_1}/mix).each do |match|
          video_code = match.first
          str.gsub!(youtube_url, youtube_player_code(video_code))
        end
        # URL type 2
        youtube_url.scan(/#{youtube_code_2}/mix).each do |match|
          video_code = match.first
          str = str.gsub!(youtube_url, youtube_player_code(video_code))
        end
      end#match.each
    end#self.scan
    str
  end

end

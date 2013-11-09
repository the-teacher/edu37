class String
  # EXTRACT SRC CODES for players
  # parse and include players

  def extract_src_from_object!
    # get object
    self.scan(/<\ *object.*?>.*?<\ *\/\ *object.*?>/mix).each do |object_block|
      src = object_block.scan(/src=[",'](.*?)[",']/mix).last
      unless src
        self.gsub!(object_block, '')
      else
        src = src.first

        # TODO: separate to external array
        slideshare = "http://static.slidesharecdn.com/swf/"
        youtube_0 = "http://www.youtube.com/watch[?]v="
        youtube_1 = "http://www.youtube.com/v/"
        youtube_2 = "http://www.youtube.com/embed/"

        # remove good services with URL and Bad services with empty
        unless src.scan(/#{youtube_0}|#{youtube_1}|#{slideshare}/).first
          self.gsub!(object_block, '')
        else
          self.gsub!(object_block, "\n\n"+src+"\n\n")        
        end#unless src.scan
        
      end#unless src
    end#self.scan
    self
  end
  
  def extract_src_from_iframes!
    # get iframes
    self.scan(/<\ *iframe.*?>.*?<\ *\/\ *iframe.*?>/mix).each do |iframe_block|
      # get src from iframe
      src = iframe_block.scan(/src=[",'](.*?)[",']/mix).last
      # remove unless src 
      unless src
        self.gsub!(iframe_block, '')
      else
        src = src.first

        # TODO: separate to external array
        vimeo = "http://player.vimeo.com/video/"
        slideshare = "http://www.slideshare.net/slideshow/embed_code/"
        youtube = "http://www.youtube.com/embed/"
        google_doc = "https://docs.google.com/document/"
        google_present = "https://docs.google.com/present/"
        google_sheets = "https://spreadsheets.google.com/spreadsheet/"

        # remove good services with URL and Bad services with empty
        unless src.scan(/#{vimeo}|#{slideshare}|#{youtube}|#{google_doc}|#{google_present}|#{google_sheets}/).first
          self.gsub!(iframe_block, '')
        else
          self.gsub!(iframe_block, "\n\n"+src+"\n\n")
        end#unless src.scan
      end#unless src
    end#self.scan
    self
  end#fn

  def extract_src_from_registrated_hostings!
    self.extract_src_from_object!
    self.extract_src_from_iframes!
    self
  end

  def links_to_players
    self.youtube_links_to_players.vimeo_links_to_players.slideshare_links_to_players.google_documents
  end

end#String

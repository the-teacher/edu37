class String
  # GOOGLE DOC  ===================================================================
  def google_doc_player_code(element_code)
    width = 480
    height = 360

    player_code = <<-PLAYER
    <div class="google_doc_block">
      <iframe src="https://docs.google.com/document/pub?id=#{element_code}" width="#{width}" height="#{height}"></iframe>
    </div>
    PLAYER

    "\n"+player_code.gsub("\n", '').gsub(/ {2,}/, '') # player to line
  end

  def google_present_player_code(element_code)
    width = 480
    height = 360

    player_code = <<-PLAYER
    <div class="google_doc_block">
      <iframe src="https://docs.google.com/present/embed?id=#{element_code}" frameborder="0" width="#{width}" height="#{height}"></iframe>
    </div>
    PLAYER

    "\n"+player_code.gsub("\n", '').gsub(/ {2,}/, '') # player to line
  end

  def google_sheet_player_code(element_code)
    width = 480
    height = 360

    player_code = <<-PLAYER
    <div class="google_doc_block">
      <iframe src="https://spreadsheets.google.com/spreadsheet/pub?key=#{element_code}" frameborder="0" width="#{width}" height="#{height}"></iframe>
    </div>
    PLAYER

    "\n"+player_code.gsub("\n", '').gsub(/ {2,}/, '') # player to line
  end

  def google_documents
    google_doc  = "https://docs.google.com/document/pub[?]+id=[a-zA-Z0-9_&;?=-]*"
    doc_code    = "https://docs.google.com/document/pub[?]+id=([a-zA-Z0-9_&;?=-]*)"

    google_present  = "https://docs.google.com/present/embed[?]+id=[a-zA-Z0-9_&;?=-]*"
    present_code = "https://docs.google.com/present/embed[?]+id=([a-zA-Z0-9_&;?=-]*)"

    google_sheet = "https://spreadsheets.google.com/spreadsheet/pub[?][a-zA-Z0-9_&;?=-]*"
    sheet_code = "https://spreadsheets.google.com/spreadsheet/pub[?][a-zA-Z0-9_&;?=-]*key=([a-zA-Z0-9_&;?=-]*)"

    str = self.dup
    str.scan(/#{google_doc}|#{google_present}|#{google_sheet}/mix).each do |match|
      match.each do |gdoc_url|
        # URL type 1
        gdoc_url.scan(/#{doc_code}/mix).each do |match|
          elem_code = match.first
          str.gsub!(gdoc_url, google_doc_player_code(elem_code))
        end#gdoc_url.scan


        # URL type 2
        gdoc_url.scan(/#{present_code}/mix).each do |match|
          elem_code = match.first
          str.gsub!(gdoc_url, google_present_player_code(elem_code))
        end#gdoc_url.scan

        # URL type 3
        gdoc_url.scan(/#{sheet_code}/mix).each do |match|
          elem_code = match.first
          str.gsub!(gdoc_url, google_sheet_player_code(elem_code))
        end#gdoc_url.scan

      end#match.each
    end#str.scan
    str
  end

end

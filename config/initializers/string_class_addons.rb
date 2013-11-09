class String

  # EXTRIMLY SIMPLE BLACKLIST
  # text.blacklist [:object, :embed, :params, :iframe]
  def blacklist! tags= []
    tags.each do |tag|
      # --<tag>QWERTYUIOP</tag>-- destroy containers
      self.gsub!(/(<#{tag.to_s}>.*?<\/#{tag.to_s}>)/mix, '')
      # --<tag> | <tag> | <tag /> | <tag src='danger' />-- destroy stand alone tags
      self.gsub!(/(<#{tag.to_s}.*?>|<\/#{tag.to_s}.*?>|<#{tag.to_s}.*?\/>)/mix, '')
    end
    self
  end

  def html_safe_for_content
    self.gsub('<', '&lt;').gsub('>', '&gt;')
  end

  def html_unsafe_for_content
    self.gsub('&lt;', '<').gsub('&gt;', '>')
  end

  def downcase_code_langs!
    self.scan(/(@@@([\w\#\-]+)@@@)/mix).each do |match|
      self.gsub!(/#{match[0]}/, "@@@#{match[1].downcase}@@@")
    end
  end

  def notextile_block_restore!
    self.scan(/(&lt;notextile&gt;([\s\S]+?)&lt;\/notextile&gt;)/mix).each do |elem|
      line = elem[0]
      code = elem[1]
      self.gsub!(line, "<notextile>#{code.html_unsafe_for_content}</notextile>")
    end
  end

  # remove_incorrect_code_langs: @@@CrAzY@@@ => @@@text@@@
  def remove_incorrect_code_langs langs = []
    self if langs.empty?
    list= langs.join('|').gsub('#', '\#') # remove # with \#
    self.gsub(/@@@(#{list})@@@/mix, '@@@text@@@')
  end

  # select from text @@@LANG@@@ codes and define using langs for highlight
  def get_code_langs
    correct_langs= []
    incorrect_langs= []
    self.scan(/@@@([\w\#\-]+)@@@/mix).each do |elem|
      lang = elem[0].downcase.to_sym
      if Project::CODE_LANGS.include?(lang)
        correct_langs.push lang
      else
        incorrect_langs.push lang
      end
    end
    {:correct=>correct_langs.uniq, :incorrect=>incorrect_langs.uniq}
  end

  def code_blocks_parser
    langs = Project::CODE_LANGS.dup
    langs.delete(:"c#"); langs.push('c\#')
    langs.delete(:"c-sharp"); langs.push('c\-sharp')
  
    langs = langs.join('|')
    str = self.dup
    str.scan(/(@@@(#{langs})@@@([\s\S]+?)@@@)/mix).each do |elem|
      line = elem[0]
      lang = elem[1]
      code = elem[2]
      str.gsub!(line, "<notextile><code class='brush: #{lang}'>#{code.html_safe_for_content}</code></notextile>")
    end
    str
  end

  def noendl
    self.gsub("\n", '')
  end

  def endl2br
    self.gsub("\n", "<br />")
  end

  # create simple anchors for textile markup
  # sharps2anchor : ###anchor_name => to a#anchor_name
  # "Hello World! ###world I'm String!".sharps2anchor => Hello World! <a href="#world" name="world" title="world"></a> I'm String!
  def sharps2anchor
    str = self.gsub(/###(\S*)/, " <a name=\"\\1\" href=\"#\\1\" title=\"\\1\"></a> ")
    return str
  end

  # 
  # `^@#$&№%*«»!?.,:;{}()<>+|/~
  # "`^@#$&№%*«»!?.,:;{}()<>+|/~".gsub(/\`|(\^)|@|#|$|&|№|%|\*|«|»|!|\?|\.|\,|:|;|\{|\}|\(|\)|<|>|\+|\||\/|~/i,'-')
  # => "--------------------------"
  def text_symbols2dash
    return self.gsub(/\`|(\^)|@|#|\$|&|№|%|\*|«|»|!|\?|\.|\,|:|;|\{|\}|\(|\)|<|>|\+|\||\/|~/i,'-')
  end

  def spaces2dash
     return self.gsub(/\n|\t|(\s)+/i, '-').gsub(/-+/i,'-')
  end

  def dashes2space
    return self.gsub(/-+/i, ' ')
  end

  def strip_dashes
    return self.gsub(/^(-)/i,'').gsub(/(-)$/i,'')
  end

  def underscore2dash
     return self.gsub(/_/i, '-')
  end

  def remove_quotes
    return self.gsub('"', '').gsub("'", '')
  end

end#String

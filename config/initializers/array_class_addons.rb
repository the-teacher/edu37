class Array

  def to_hightlight_js_array
    return [] if self.empty?
    js_files_array = ['syntax_highlighter/shCore']
    langs = self.get_names_of_highlight_brashes
    langs.each{ |lang| js_files_array.push('syntax_highlighter/shBrush' + lang.to_s.capitalize) }
    js_files_array
  end

  def to_hightlight_css_array
    return [] if self.empty?
    [
      'syntax_highlighter/shCore',
      'syntax_highlighter/shThemeDefault',
      'syntax_highlighter/style'
    ]
  end

=begin
      a = [:bash, :shell,
      :cpp, :c,
      :"c#", :"c-sharp", :csharp,
      :css,
      :delphi, :pascal,
      :diff, :patch,
      :groovy,
      :java,
      :js, :jscript, :javascript,
      :perl, :pl,
      :php, :php4, :php5,
      :text, :txt, :plain,
      :python, :py,
      :ruby, :rb,
      :scala,
      :sql,
      :vb, :vbnet,
      :xml, :xhtml, :xslt, :html, :xhtml]

      a.get_names_of_highlight_brashes
      => [:css, :groovy, :java, :scala, :sql, :bash, :cpp, :csharp, :delphi, :diff, :jscript, :perl, :php, :text, :python, :ruby, :vb, :xml]
=end

  # TODO: REFACTOR THIS if you can, plz!
  # [:cpp, :js, :javascript, :c] => [:cpp, :jscript]   
  def get_names_of_highlight_brashes
      arr = self

      if arr.include?(:bash) || arr.include?(:shell)
        arr.delete(:bash) ; arr.delete(:shell)
        arr.push :bash
      end

      if arr.include?(:cpp) || arr.include?(:c)
        arr.delete(:cpp) ; arr.delete(:c)
        arr.push :cpp
      end

      if arr.include?(:"c#") || arr.include?(:"c-sharp") || arr.include?(:csharp)
        arr.delete(:"c#") ; arr.delete(:"c-sharp") ; arr.delete(:csharp) 
        arr.push :csharp
      end

      if arr.include?(:delphi) || arr.include?(:pascal)
        arr.delete(:delphi) ; arr.delete(:pascal)
        arr.push :delphi
      end

      if arr.include?(:diff) || arr.include?(:patch)
        arr.delete(:diff) ; arr.delete(:patch)
        arr.push :diff
      end

      if arr.include?(:js) || arr.include?(:jscript) || arr.include?(:javascript)
        arr.delete(:js) ; arr.delete(:jscript) ; arr.delete(:javascript) 
        arr.push :jscript
      end

      if arr.include?(:perl) || arr.include?(:pl)
        arr.delete(:perl) ; arr.delete(:pl)
        arr.push :perl
      end

      if arr.include?(:php) || arr.include?(:php4) || arr.include?(:php5)
        arr.delete(:php) ; arr.delete(:php4) ; arr.delete(:php5) 
        arr.push :php
      end

      if arr.include?(:text) || arr.include?(:txt) || arr.include?(:plain)
        arr.delete(:text) ; arr.delete(:txt) ; arr.delete(:plain) 
        arr.push :text
      end

      if arr.include?(:python) || arr.include?(:py)
        arr.delete(:python) ; arr.delete(:py)
        arr.push :python
      end

      if arr.include?(:ruby) || arr.include?(:rb)
        arr.delete(:ruby) ; arr.delete(:rb)
        arr.push :ruby
      end

      if arr.include?(:vb) || arr.include?(:vbnet) || arr.include?(:basic)
        arr.delete(:vb) ; arr.delete(:vbnet) ; arr.delete(:basic)
        arr.push :vb
      end

      if arr.include?(:xml) || arr.include?(:xhtml) || arr.include?(:xslt) || arr.include?(:html)
        arr.delete(:xml) ; arr.delete(:xhtml) ; arr.delete(:xslt) ;  arr.delete(:html)
        arr.push :xml
      end
      arr
  end#get_names_of_highlight_brashes
end#Array

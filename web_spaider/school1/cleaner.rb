require 'rubygems'
require 'sanitize'

module SatitizeRules  
  module Config
    #SatitizeRules::Config::TOTAL
    TOTAL = {}

    #SatitizeRules::Config::CLEAR
    BASE = {
      :elements => ['img'],
      :attributes => {
        'img' => ['alt', 'src', 'title']
      }
    }
  end
end

range = (50..491)

range.each do |i|
  puts "parse #{i}"
  src = File.open("news_#{i}.txt", 'r')
  
  str = src.read

  pattern = '<td valign="top" colspan="2">.*</td>'
  js="<script language='JavaScript' type='text/javascript'>.*</script>"

 
  str.scan(/#{pattern}/mi) do |html|
    html.gsub!(/#{js}/mi, '')
    txt = Sanitize.clean(html, SatitizeRules::Config::TOTAL).gsub("\t", '')
    res = File.open("clear/news_#{i}.txt", 'w')
    res.write(txt)
    res.close
  end

  src.close
end

range.each do |i|
  puts "clean #{i}"
  file_name = "clear/news_#{i}.txt"
  if File.exists? file_name
    src = File.open(file_name, 'r')
    str = src.read
    left_right= "\n{1,}«.*?»"
    str.gsub!(/#{left_right}/mi, '')
    str.gsub!(/\s*Вернуться\s*/mi, '').gsub!(/\s{2,}/mi,"\n\n")

    File.delete(file_name)
    src = File.open(file_name, 'w')
    src.write(str)
    src.close
  end
end

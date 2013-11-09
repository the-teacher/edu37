#require 'cgi' unless defined?(CGI)
require 'iconv'
require 'open-uri'

(50..491).each do |i|

  url = "http://school1.ivedu.ru/index.php?option=com_content&task=view&id=#{i}&Itemid=2" 
  f = File.open("news_#{i}.txt", 'w')

  open url  do |file|
    file.each_line do |line|
      f.write Iconv.new('utf-8', 'windows-1251//IGNORE').iconv(line)
    end
  end

  f.close

end

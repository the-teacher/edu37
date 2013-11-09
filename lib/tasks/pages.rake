namespace :db do
  namespace :pages do
    
    desc 'create test pages for users'
    # rake db:pages:create
    task :create => :environment do
      puts 'Pages creating'

      users= User.find(:all)

      def page_data_for u, num
        text = Faker::Lorem.sentence(30) # paragraphs(50) why it's an Array? 
        {
            :author=>Faker::Name.name,
            :keywords=>Faker::Lorem.sentence(2),
            :description=>Faker::Lorem.sentence(2),
            :copyright=>Faker::Name.name,
            :title=>"#{num} : #{u.login} : #{Faker::Lorem.sentence(3)}",
            :html_content=>text,
            :tag_list=>'test',
            :textile_content=>text
        }
      end

      users.each do |u|
        10.times do |i|
          page= u.pages.new
          page.attributes= page_data_for(u, i)
          page.save
          page.send([:to_published, :to_personal, :to_draft, :to_blocked].shuffle.first)
          puts 'page --'

          if [true, false].shuffle.first
            10.times do |j|
              child_page= u.pages.new
              child_page.attributes= page_data_for(u, j)
              child_page.save
              child_page.move_to_child_of page
              puts 'page -- --'

              if [true, false].shuffle.first
                10.times do |k|
                  level_child_page= u.pages.new
                  level_child_page.attributes= page_data_for(u, k)
                  level_child_page.save
                  level_child_page.move_to_child_of child_page
                  puts 'page -- -- --'
                end# n.times do
              end# [true, false].shuffle.first

            end# n.times do
          end# [true, false].shuffle.first   

        end# n.times do
      end# users.each do |u|

      puts 'Pages created'
    end# db:pages:pages
  end#:pages
end#:db

namespace :db do
  namespace :publications do
    
    desc 'create test publications for users'
    # rake db:publications:create
    task :create => :environment do
      puts 'publications creating'

      users= User.find(:all)

      def publication_data_for u, num
        text = Faker::Lorem.sentence(30) # paragraphs(50) why it's an Array? 
        {
            :author=>Faker::Name.name,
            :keywords=>Faker::Lorem.sentence(2),
            :description=>Faker::Lorem.sentence(2),
            :copyright=>Faker::Name.name,

            :title=>"#{num} : #{u.login} : #{Faker::Lorem.sentence(3)}",

            :textile_annotation=>Faker::Lorem.sentence(10),
            :html_annotation=>Faker::Lorem.sentence(10),

            :textile_content=>text,
            :html_content=>text
        }
      end

      num = 1
      users.each do |u|
        30.times do |i|
          publication= u.publications.new
          publication.attributes= publication_data_for(u, i)
          publication.tag_list = ['math', 'bio', 'phys', 'it', 'culture'].rand
          publication.save!
          publication.send([:to_published, :to_unsafe, :to_draft].rand.to_s)
          puts "publication #{num}"
          num = num.next
        end# n.times do
      end# users.each do |u|

      puts 'publications created'
    end# db:publications:create
  end#:publications
end#:db

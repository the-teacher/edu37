namespace :db do
  namespace :topics do

    # rake db:topics:create
    desc 'create topics for development'
    task :create => :environment do
      puts 'topics creating'

      Topic.destroy_all
      # (:limit=>40)
      Forum.all.each do |f|
        5.times do |i|
          f.topics.new(:title=>Faker::Lorem.sentence(3)).save!
          puts "forum #{f.id} topic #{i}"
        end
      end

      puts 'topics created'
    end# db:topics:create    
  end#:topics
end#:db

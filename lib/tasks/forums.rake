namespace :db do
  namespace :forums do

    # rake db:forums:create
    desc 'create forums for development'
    task :create => :environment do
      puts 'forums creating'

      Forum.destroy_all
      # (:limit=>5)
      User.all.each do |u|
        5.times do |i|
          u.forums.new(:title=>Faker::Lorem.sentence(3), :description=>Faker::Lorem.sentence(3)).save!
          puts "#{u.login} forum #{i}"
        end
      end

      puts 'forums created'
    end# db:forums:create    
  end#:forums
end#:db

namespace :db do
  namespace :comments do

    # rake db:comments:create
    desc 'create comments for development'
    task :create => :environment do
      puts 'Comments creating'

      i = 1
      pages = Page.all
      pages.each do |p|
        5.times do
          some_user = User.all.rand
          Comment.new(
            :title=>Faker::Name.name,
            :contacts=>'test@test.com',
            :textile_content=>Faker::Lorem.sentence(2),
            :state=>[:unsafe, :safe, :undesirable, :blocked, :deleted].rand.to_s
          ).init(p, :user=>some_user).save!
          puts "comment #{i} for page #{p.id}"
          i = i.next    
        end#n.times
      end#pages.each

      i = 1
      publications = Publication.all
      publications.each do |r|
        5.times do
          some_user = User.all.rand
          Comment.new(
            :title=>Faker::Name.name,
            :contacts=>'test@test.com',
            :textile_content=>Faker::Lorem.sentence(2),
            :state=>[:unsafe, :safe, :undesirable, :blocked, :deleted].rand.to_s
          ).init(r, :user=>some_user).save!
          puts "comment #{i} for publication #{r.id}"
          i = i.next    
        end#n.times
      end#publications.each

      i = 1
      users = User.all
      users.each do |u|
        5.times do
          some_user = User.all.rand
          Comment.new(
            :title=>Faker::Name.name,
            :contacts=>'test@test.com',
            :textile_content=>Faker::Lorem.sentence(2),
            :state=>[:unsafe, :safe, :undesirable, :blocked, :deleted].rand.to_s
          ).init(u, :user=>some_user).save!
          puts "comment #{i} for user #{u.id}"
          i = i.next    
        end#n.times
      end#users.each

      puts 'Comments created'
    end# db:comments:create
  end#:comments
end#:db

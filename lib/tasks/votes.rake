namespace :db do
  namespace :votes do

    # rake db:votes:create
    desc 'create votes for development'
    task :create => :environment do
      puts 'votes creating'

      votes = [1, -1, 1.5, -1.5, 3, -3, 2, -2]
      User.all.each do |u|
        20.times do |i|
          val= votes.shuffle.first
          u.votes.new(:value=>val).save
          puts "vote #{i} with #{val} for user #{u.id}"
        end
      end

      Page.all.each do |p|
        20.times do |i|
          val= votes.shuffle.first
          p.votes.new(:value=>val).save
          puts "vote #{i} with #{val} for page #{p.id}"
        end
      end

      Publication.all.each do |r|
        20.times do |i|
          val= votes.shuffle.first
          r.votes.new(:value=>val).save
          puts "vote #{i} with #{val} for publication #{r.id}"
        end
      end

      Comment.all.each do |c|
        5.times do |i|
          val= votes.shuffle.first
          c.votes.new(:value=>val).save
          puts "vote #{i} with #{val} for comment #{c.id}"
        end
      end

      Forum.all.each do |f|
        5.times do |i|
          val= votes.shuffle.first
          f.votes.new(:value=>val).save
          puts "vote #{i} with #{val} for forum #{f.id}"
        end
      end

      Topic.all.each do |t|
        5.times do |i|
          val= votes.shuffle.first
          t.votes.new(:value=>val).save
          puts "vote #{i} with #{val} for topic #{t.id}"
        end
      end

      puts 'votes created'
    end# db:votes:create    
  end#:votes
end#:db

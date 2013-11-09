namespace :db do
  namespace :tags do

    # rake db:tags:create
    desc 'create tags for development'
    task :create => :environment do
      puts 'Tags creating'

      i = 1
      ranks = [:admin, :school, :chuck_norris, :godzilla]
      User.all.each do |u|
        u.rank_list = ranks.rand
        u.save
        puts "rank list #{i} created"
        i = i.next
      end

      j = 1
      tags = ['mother day', 'victory', 'competitions', 'travel and work', 'Russia', 'Ruby on Rails']
      Page.all.each do |p|
        p.tag_list = [tags.rand, tags.rand, tags.rand].join(', ')
        p.save
        puts "tag list #{j} created"
        j = j.next
      end
      
      puts 'Tags created'
    end# db:tags:create    
  end#:tags
end#:db

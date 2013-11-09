namespace :db do
  namespace :storages do

    # rake db:storages:create
    desc 'create storages for development'
    task :create => :environment do
      puts 'Storages creating'

      User.all.each do |user|
        user.storages.new(:title=>'Images').save
        user.storages.new(:title=>'Text files').save
        user.storages.new(:title=>'Video files').save
        user.storages.new(:title=>'Presentations').save
        user.storages.new(:title=>'Other').save
        puts '.'
      end#User.all.each

      puts 'Storages created'
    end#db:storages:create    
  end#:storages
end#:db

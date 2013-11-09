namespace :db do
  namespace :users do

    # rake db:users:create
    desc 'create users for development'
    task :create => :environment do
      puts 'Basic users creating'

      admin = Role.find_by_name(:admin)
      user = Role.find_by_name(:user)
      demo = Role.find_by_name(:demo)

      u = User.new(
        :login=> ' RooT   ',
        :email=> 'zykin-ilya@ya.ru',
        :name=>'Zykin Ilya',
        :password=>'qwerty',
        :password_confirmation=>'qwerty'
      )
      u.role= admin
      u.save!
      puts "==> User root created"

      u = User.new(
        :login => 'AleX',
        :email => 'alex@josephstalin.com',
        :name=>'Alex'
      )
      u.role= user
      u.save!
      puts "==> User Alex created"

      u = User.new(
        :login=> ' Demo   ',
        :email=> 'demo@zykin-ilya.ru',
        :name=>'Demo user',
        :password=>'1234567',
        :password_confirmation=>'1234567'
      )
      u.role= demo
      u.save!
      puts "==> User DEMO created"

      puts 'Basic users created'
    end# db:users:create
    
  end#:users
end#:db

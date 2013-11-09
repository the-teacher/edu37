namespace :db do
  namespace :uploaded_files do

    # rake db:uploaded_files:create
    desc 'create uploaded_files for development'
    task :create => :environment do
      puts 'Uploaded files creating'
      
      i = 1
      User.all.each do |user|
        user.storages.all.each do |s|

          50.times do |i|
            f = s.uploaded_files.new(:title=>"Test file #{s.title}::#{i.to_s}", :file_file_size=>24.kilobytes)          
            f.user = user
            f.save!
            puts "uploaded file #{i}"
            i = i.next
          end#n.times

        end#user.storages.all.each
      end#User.all.each

      puts 'Uploaded files created'
    end#db:uploaded_files:create
  end#:uploaded_files
end#:db

namespace :db do
  namespace :comments do

    # rake db:comments:create_for_forum
    desc 'create comments for development'
    task :create_for_forum => :environment do
      puts 'Comments for forum creating'

      i = 1
      users= User.all(:select=>[:id, :zip, :login])
      topics= Topic.all #(:limit=>30)
      topics.each do |t|
        5.times do
          sender= users.shuffle.first
          recipient= users.shuffle.first
          while sender.id == recipient.id do
            recipient= users.shuffle.first
            puts "users identical - suffle one more time"
          end

          t.comments.new(
            :title=>Faker::Lorem.sentence(3),
            :contacts=>Faker::Internet.email,
            :textile_content=>Faker::Lorem.sentence(2),

            :sender_user_id => sender.id,
            :sender_user_zip => sender.zip,
            :sender_user_login => sender.login,

            :recipient_user_id => recipient.id,
            :recipient_user_zip => recipient.zip,
            :recipient_user_login => recipient.login,

            :state=>[:unsafe, :safe, :undesirable, :blocked, :deleted].rand.to_s
          ).save!
          puts "comment #{i} for forum topic #{t.id}"
          i = i.next
        end#n.times
      end#pages.each

      puts 'Comments for forum created'
    end# db:comments:create_for_forum
  end#:comments
end#:db

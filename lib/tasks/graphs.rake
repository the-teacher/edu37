namespace :db do
  namespace :graphs do

    # rake db:graphs:create
    desc 'create graphs for development'
    task :create => :environment do
      user = Role.find_by_name(:user)

      pass = User::random_password
      puts 'Test users creating'
      100.times do |i|
        u = User.new(
          :login => "user#{i}",
          :email => "test-user#{i}@ya.ru",
          :name=>"User Number #{i}"
        )
        u.set_role user
        u.save
        puts "test user #{i} created"
      end#n.times
      puts 'Test users created'

      contexts = [:live, :web, :school, :job, :military, :family]
      roles={
        :live=>[:friend,:friend],
        :web=>[:moderator, :user],
        :school=>[:teacher, :student],
        :job=>[:chief, :worker],
        :military=>[:officer, :soldier],
        :family=>[:child, :parent]
      }

       users = User.where("id > 10 and id < 80") #70 users
       test_count = 1000
       test_count.times do |i|
          sender = users[rand(69)]
          recipient = users[rand(69)]

          context = contexts.rand       # :job
          role = roles[context].shuffle # [:worker, :chif]
          # trace
          p "test graph #{i}/#{test_count} " + sender.class.to_s+" to "+recipient.class.to_s + " with context: " + context.to_s
          
          graph = sender.graph_to(recipient, :context=>context, :me_as=>role.first, :him_as=>role.last)
          graph.save
          # set graph state
          reaction = [:accept, :reject, :delete, :initial].rand
          graph.send(reaction)
       end# n.times
      
    end# db:graphs:create
  end#:graphs
end#:db

namespace :app do
  namespace :create do

    # rake app:create:data
    desc 'create basic data for application'
    task :data => ['db:drop:all', 'db:create:all', 'db:migrate', 'db:roles:create', 'db:users:create', 'db:pages:create', 'db:publications:create', 'db:comments:create',  'db:storages:create', 'db:uploaded_files:create', 'db:tags:create', 'db:graphs:create', 'db:forums:create', 'db:topics:create', 'db:comments:create_for_forum', 'db:votes:create']

    # rake app:create:mini_data
    desc 'create mini data for application'
    task :mini_data => ['db:drop:all', 'db:create:all', 'db:migrate', 'db:roles:create', 'db:users:create']
  
  end #:create
end #:app

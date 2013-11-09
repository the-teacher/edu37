namespace :db do
  namespace :roles do

    # rake db:roles:create
    desc 'create roles for development'
    task :create => :environment do
      puts 'Roles creating'

      # ADMIN
      role= {
        :system=>{
          :administrator=>true
        }
      }

      r = Role.new(
        :name => :admin,
        :title => 'Administrator',
        :description=>'Role (policy set) for admin',
        :settings=>role.to_yaml
      )
      r.save!
      puts "==> Admin role created"

      # USER
      role= {
        # users/edit - it's profiles/edit
        :users=>{
          :cabinet=>true,
          :update=>true,
          :avatar_upload=>true,
          :site_header_upload=>true
        },
        :profiles=>{
          :edit=>true,
          :update=>true,
          :advanced_fields=>false,
          :api=>false,
          :tags=>false,
          :state_buttons=>false
        },
        :publications=>{
          :manage=>true,
          :new=>true,
          :create=>true,
          :edit=>true,
          :update=>true,
          :destroy=>true,
          :tags=>false,
          :rebuild=>true,
          :state_buttons=>true,
          :moderation_state_icon=>false
        },
        :pages=>{
          :manage=>true,
          :new=>true,
          :create=>true,
          :edit=>true,
          :update=>true,
          :destroy=>true,
          :tags=>false,
          :rebuild=>true,
          :state_buttons=>true,
          :moderation_state_icon=>false
        },
        :storages=>{
          :manage=>true,
          :new=>true,
          :create=>true,
          :edit=>true,
          :update=>true,
          :destroy=>true,
          :tags=>false,
          :rebuild=>false,
          :state_buttons=>false,
          :state_icon=>false,
          :moderation_state_icon=>false
        },
        :uploaded_files=>{
          :create=>true,
          :destroy=>true
        },
        :form_buttons=>{
          :advanced_states=>true
        },
        :markup=>{
          :advanced=>false
        }
      }

      r = Role.new(
        :name => :user,
        :title => 'User',
        :description=>"Role (policy set) for User",
        :settings=>role.to_yaml
      )
      r.save

      puts "==> User role created"

      # DEMO
      role= {
        # users/edit - it's profiles/edit
        :users=>{
          :cabinet=>true,
          :update=>false,
          :avatar_upload=>false,
          :site_header_upload=>false
        },
        :profiles=>{
          :edit=>true,
          :update=>false,
          :advanced_fields=>false,
          :api=>false,
          :tags=>false,
          :state_buttons=>false
        },
        :publications=>{
          :manage=>true,
          :new=>true,
          :create=>false,
          :edit=>true,
          :update=>false,
          :destroy=>false,
          :tags=>false,
          :rebuild=>false,
          :state_buttons=>true,
          :moderation_state_icon=>false
        },
        :pages=>{
          :manage=>true,
          :new=>true,
          :create=>false,
          :edit=>true,
          :update=>false,
          :destroy=>false,
          :tags=>false,
          :rebuild=>false,
          :state_buttons=>true,
          :moderation_state_icon=>false
        },
        :storages=>{
          :manage=>true,
          :new=>true,
          :create=>false,
          :edit=>true,
          :update=>false,
          :destroy=>false,
          :tags=>false,
          :rebuild=>false,
          :state_buttons=>false,
          :state_icon=>false,
          :moderation_state_icon=>false
        },
        :uploaded_files=>{
          :create=>false,
          :destroy=>false
        },
        :form_buttons=>{
          :advanced_states=>false
        },
        :markup=>{
          :advanced=>false
        }
      }

      r = Role.new(
        :name => :demo,
        :title => 'Demo',
        :description=>"Role (policy set) for DEMO",
        :settings=>role.to_yaml
      )
      r.save

      puts "==> DEMO role created"

      puts 'Roles created'
    end# db:roles:create
    
  end#:roles
end#:db

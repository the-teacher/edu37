require 'digest/sha1'

class User < ActiveRecord::Base
  include Authentication
  include Authentication::ByPassword
  include Authentication::ByCookieToken

  # HACK HACK HACK -- how to do attr_accessible from here?
  # prevents a user from submitting a crafted form that bypasses activation
  # anything else you want your user to change should be added here.
  attr_accessible :zip, :login, :email, :name, :password, :password_confirmation
  attr_accessible :avatar, :avatar_file_name, :avatar_content_type, :avatar_file_size, :avatar_updated_at
  attr_accessible :site_header, :site_header_file_name, :site_header_content_type, :site_header_file_size, :site_header_updated_at
  attr_accessible :files_count, :files_size, :files_max_volume
  attr_accessible :show_count, :positive_value, :negative_value
  # TODO: to do it safe!
  attr_accessible :role_id

  acts_as_taggable_on :ranks

  def to_param
    self.zip
  end

  has_one   :profile
  has_many  :pages
  has_many  :audits
  has_many  :forums
  has_many  :topics
  has_many  :storages
  has_many  :publications
  has_many  :uploaded_files
  # has_many  :questions
  # has_many  :update_events

  # SCOPES
  scope :fresh,   order('created_at DESC')
  scope :oldest,  order('created_at ASC')

  has_many  :votes, :as=>:object            # votes (as votable object)
  has_many  :my_votes, :class_name=>'Vote'  # votes (as owner)

  # comments
  has_many  :comments, :as=>:object
  has_many  :incoming_comments, :class_name=>'Comment', :foreign_key=>:user_id
  has_many  :created_comments,  :class_name=>'Comment', :foreign_key=>:creator_id

  #:presence   => {:message => I18n.translate('authentication.login_presence')},
  #:length     => { :within => 3..40 },
  validates :login, :uniqueness => {:message => I18n.translate('authentication.login_uniqueness')}
  validates :zip,   :uniqueness => {:message => I18n.translate('users.uniqueness.zip')}

  validates :login, :format     => { :with => Authentication.login_regex, :message => I18n.translate('authentication.bad_login_message') },
                    :unless     => Proc.new{ |user| user.login.blank? }

  validates :name,  :format     => { :with => Authentication.name_regex, :message => I18n.translate('authentication.bad_name_message') },
                    :length     => { :maximum => 100 },
                    :allow_nil  => true

  validates :email, :presence   => true,
                    :uniqueness => true,
                    :format     => { :with => Authentication.email_regex, :message => I18n.translate('authentication.bad_email_message')},
                    :length     => { :within => 6..100 }

  # PAPPERCLIP IMAGES

  img_types = ['image/jpg', 'image/jpeg', 'image/pjpeg', 'image/gif', 'image/png', 'image/x-png']

  # TODO: has_many :avatars (?)
  # AVATAR
  has_attached_file :avatar,
    :styles => {
        :normal => ["200x300#", :jpg],
        :small => ["100x150#", :jpg],
        :mini  => ["50x75#", :jpg],
        :micro  => ["25x38#", :jpg],
        :micro_mozaic => ["25x25#", :jpg]
    },
    :convert_options => {:all => "-strip"},
    :url => Project::AVATARA_URL,
    :default_url=>Project::AVATARA_DEFAULT

  # SITE HEADER
  has_attached_file :site_header,
    :styles =>          {:normal => ["1000x180#", :jpg]},
    :convert_options => {:all => "-strip"},
    :url => Project::SITE_HEADER_URL,
    :default_url=>Project::SITE_HEADER_DEFAULT

  # TODO: error page 413 for files > 2MB
  validates_attachment_content_type :avatar, :content_type => img_types,        :message=>'incorrect file type'
  validates_attachment_size         :avatar, :in => 2.kilobytes..300.kilobytes, :message=>'incorrect file size'

  # TODO: validate size '900x250px'
  validates_attachment_content_type :site_header, :content_type => img_types,        :message=>'incorrect file type'
  validates_attachment_size         :site_header, :in => 2.kilobytes..500.kilobytes, :message=>'incorrect file size'

  # prepare avatar and site_header file names
  before_save :prepare_file_name
  def prepare_file_name
    if self.avatar_file_name_changed?
      avatar_name= Russian.translit(self.avatar_file_name).downcase
      extension=  File.extname(avatar_name)
      file_name= File.basename(avatar_name, extension)
      file_name= file_name.text_symbols2dash.remove_quotes.underscore2dash.spaces2dash.strip_dashes
      self.avatar.instance_write(:file_name, "#{file_name}#{extension}")
    end

    if self.site_header_file_name_changed?
      site_header_name= Russian.translit(self.site_header_file_name).downcase
      extension=  File.extname(site_header_name)
      file_name= File.basename(site_header_name, extension)
      file_name= file_name.text_symbols2dash.remove_quotes.underscore2dash.spaces2dash.strip_dashes
      self.site_header.instance_write(:file_name, "#{file_name}#{extension}")
    end
  end
  # ~prepare avatar and site_header file names

  # OTHER

  # TODO: to remake
  def new_questions
    self.questions.select {|q| q.state == "new_question"}
  end

  def site_name
    if login == Project::ROOT_LOGIN
      Project::ROOT_DOMAIN
    else
      "#{login}.#{Project::ROOT_DOMAIN}"
    end
  end
  
  def subdomain
    return false if login == Project::ROOT_LOGIN
    login
  end

  def is_main?
    login == Project::ROOT_LOGIN
  end

  # ROLES
  belongs_to :role

  def update_role(role)
    self.update_attribute(:role, role)
  end

  def role_hash
    @role_hash ||= (self.role ? (self.role.settings.is_a?(String) ? YAML::load(self.role.settings) : Hash.new) : Hash.new )
  end
  
  # HELPERS
  def top_manager?
    self.has_role?(false, false)
  end

  def top_manager_of? section
    self.has_role?(section, false)
  end

  # TODO: delete 29.05.2011
  #def has_access?(section, policy)
  #  self.has_role?(section, policy)
  #end

  # TRUE if user has role - administartor of system
  # TRUE if user is moderator of this section (controller_name)
  # FALSE when this section (or role) is nil
  # return current value of role (TRUE|FALSE)
  def has_role?(section, policy)
    section=  section.to_s
    policy=   policy.to_s
    return true   if      role_hash[:system]        && role_hash[:system][:administrator]     && role_hash[:system][:administrator].is_a?(TrueClass)
    return true   if      role_hash[:moderator]     && role_hash[:moderator][section.to_sym]  && role_hash[:moderator][section.to_sym].is_a?(TrueClass)
    return false  unless  role_hash[section.to_sym] && role_hash[section.to_sym][policy.to_sym]
    role_hash[section.to_sym][policy.to_sym]
  end
  
  # FALSE if object is nil
  # FALSE if object is not ActiveRecord Model
  # If object is a USER - check for youself
  # Check for owner field - :user_id
  # Check for owner _object_ if owner field is not :user_id
  # or FALSE
  def owner?(obj)
    return false unless obj
    return false unless (obj.class.superclass == ActiveRecord::Base)
    return true if self.has_role?(:system, :administrator)
    return self.id == obj.id          if obj.is_a?(User)
    return self.id == obj[:user_id]   if obj[:user_id]
    return self.id == obj[:user][:id] if obj[:user]
    false
  end
  # ROLES

  def self.random_password
    pass= ''
    pass_char= []
    nums= '123456789'
    lowcase= 'qwertyuipasdfghjklzxcvbnm'
    upcase= 'QWERTYUIPASDFGHJKLZXCVBNM'
    (nums+upcase).each_char{|c| pass_char.push c}
    6.times{pass<< pass_char.rand}
    pass
  end

  # Rails 3 syntax
  # before_validation(:on => :create){some_test} 
  before_validation do
    fields_downcase
    create_login
  end

  before_validation(:on => :create) do
    make_password    
  end

  after_create  :create_profile

  def create_login
    if login.blank?
      id = User.last.try(:id)
      id = id.nil? ? (rand*100000).to_i : id.next
      self.login= 'user' + id.to_s
    end
  end
  
  def make_password
    if password.blank?
      pass= User::random_password
      self.password= pass
      self.password_confirmation= pass
    end
  end
  
  def fields_downcase
    self.login= self.login.strip.downcase unless self.login.blank?
    self.email= self.email.strip.downcase unless self.email.blank?
  end

  def create_profile
    self.build_profile.save
  end

  # Authenticates a user by their login name and unencrypted password.  Returns the user or nil.
  #
  # uff.  this is really an authorization, not authentication routine.  
  # We really need a Dispatch Chain here or something.
  # This will also let us return a human error message.
  #
  def self.authenticate(login, password)
    return nil if login.blank? || password.blank?
    u = find_by_login(login.downcase) # need to get the salt
    u && u.authenticated?(password) ? u : nil
  end

  def login=(value)
    write_attribute :login, (value ? value.downcase : nil)
  end

  def email=(value)
    write_attribute :email, (value ? value.downcase : nil)
  end

  # SOCIAL GRAPH PROTOTYPE
  has_many  :graphs, :foreign_key=>:sender_id
  has_many  :inverted_graphs, :class_name => 'Graph', :foreign_key=>:recipient_id

  # graph magic finder : provide something like this X_Ys_from_Z aka STATE_ROLEs_from_CONTEXT
  #
  # def accepted_chiefs_from_job
  #  chiefs = graphs.accepted.where(:context => :job, :recipient_role=>:chief)        # my graphs
  #  _chiefs = inverted_graphs.accepted.where(:context => :job, :sender_role=>:chief) # foreign graphs
  #  chiefs | _chiefs
  # end
  #
  # u.accepted_friends_from_live.count
  # u.rejected_friends_from_live.count
  # u.deleted_friends_from_live.count
  #
  # u.deleted_chiefs_from_job.count
  # u.accepted_chiefs_from_job.count
  # u.rejected_chiefs_from_job.count
  #
  # u.accepted_teachers_from_school.count
  # u.deleted_teachers_from_school.count
  #
  def method_missing(method_name, *args)
    if /^(.*)_(.*)_from_(.*)$/.match(method_name.to_s)
      match = $~
      state   = match[1].to_sym
      role    = match[2].singularize.to_sym
      context = match[3].to_sym
      graphs.send(state).where(:context => context, :recipient_role=>role) | inverted_graphs.send(state).where(:context => context, :sender_role=>role)
    else
      super
    end
  end

  def graph_exists?(another_user, opts={:context=>:live, :me_as=>:friend, :him_as=>:friend})
    return true if another_user.id == self.id
    !Graph.where( :context=>opts[:context],
                  :sender_id=>self.id,
                  :sender_role=>opts[:me_as],
                  :recipient_id=>another_user,
                  :recipient_role=>[:him_as]
               ).first.nil?
  end

  # user.graph_to(another_user, :context=>:job, :me_as=>:boss, :him_as=>:staff_member)
  # user.graph_to(another_user, :context=>:school, :me_as=>:student, :him_as=>:teacher)
  # user.graph_to(another_user, :context=>:school, :me_as=>:student, :him_as=>:school)
  def graph_to(another_user, opts={:context=>:live, :me_as=>:friend, :him_as=>:friend})
    Graph.where(:context=>opts[:context], :sender_id=>self.id, :sender_role=>opts[:me_as], :recipient_id=>another_user, :recipient_role=>[:him_as]).first ||
    graphs.new( :context=>opts[:context], :sender_role=>opts[:me_as], :recipient_id=>another_user.id, :recipient_role=>opts[:him_as])
  end
  # SOCIAL GRAPH END

  protected
  # source github.com/the-teaher
end

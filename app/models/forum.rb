class Forum < ActiveRecord::Base
  def to_param
    self.zip
  end
  
  # TODO: reforming all topics data when it's update
  # TODO: delete all topics when it's delete

  belongs_to :user
  has_many :topics
  acts_as_nested_set :scope=>:user

  acts_as_taggable
  has_many  :votes,  :as=>:object

  validates_presence_of :title, :message=>'Title'

  # STATE MACHINE
  scope :for_index,   where(:state => [:restricted, :published])
  scope :for_manage,  where(:state => [:unsafe, :draft, :restricted, :published])

  # user states
  scope :draft,       where(:state => :draft)
  scope :unsafe,      where(:state => :unsafe)
  scope :deleted,     where(:state => :deleted)
  scope :archived,    where(:state => :archived)
  scope :published,   where(:state => :published)
  scope :restricted,  where(:state => :restricted)

  # moderation states
  scope :moderation_safe,    where(:moderation_state => :safe)
  scope :moderation_unsafe,  where(:moderation_state => :unsafe)
  scope :moderation_blocked, where(:moderation_state => :blocked)

  state_machine :state, :initial => :unsafe do
    event :to_published do
      transition all => :published
    end
    event :to_personal do
      transition all => :personal
    end
    event :to_draft do
      transition all => :draft
    end
    event :to_restricted do 
      transition all => :restricted
    end
    event :to_deleted do 
      transition all => :deleted
    end
    event :to_archived do 
      transition all => :archived
    end
    event :to_unsafe do 
      transition all => :unsafe
    end 
    event :clear do
      transition all => :unsafe
    end
  end

  state_machine :moderation_state, :namespace => 'moderation', :initial => :unsafe do
    event :to_safe do
      transition all => :safe
    end
    event :to_unsafe do
      transition all => :unsafe
    end
    event :to_blocked do
      transition all => :blocked
    end
    event :clear do
      transition all => :unsafe
    end
  end
  # STATE MACHINE

  def init(opts= {})
    if opts[:user]
      self.user_id=    opts[:user].id
      self.user_zip=   opts[:user].zip
      self.user_login= opts[:user].login
    end

    if opts[:creator]
      self.creator_id=    opts[:creator].id
      self.creator_zip=   opts[:creator].zip
      self.creator_login= opts[:creator].login
    end
    return self
  end

  before_save :prepare_content

  def prepare_content
    # forming inline tags
    self.tags_inline= self.tag_list.to_s
    # set scoped tags
    self.set_tag_list_on(:forums, self.tag_list)
  end

end

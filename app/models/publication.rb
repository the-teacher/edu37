class Publication < ActiveRecord::Base
  def to_param
    self.zip
  end

  def subdomain
    return false if self.user_login == Project::ROOT_LOGIN
    self.user_login
  end
  
  belongs_to :user
  acts_as_taggable
  acts_as_nested_set :scope=>:user

  has_many  :votes, :as=>:object
  has_many  :comments, :as=>:object
  has_many  :uploaded_files, :as=>:storage

  validates_presence_of :title,     :message=>I18n.translate('publications.persence.title')
  # validates_presence_of :tag_list,  :message=>I18n.translate('publications.persence.tag_list')
  
  scope :fresh,               order('created_at DESC')
  scope :oldest,              order('created_at ASC')
  scope :nested_set,          order('lft ASC')
  scope :reversed_nested_set, order('lft DESC')

  scope :for_root_index,  where(:state => [:published])
  scope :for_index,       where(:state => [:restricted, :published])
  scope :for_manage,      where(:state => [:unsafe, :draft, :restricted, :published])
  scope :for_moderation,  where(:state => [:unsafe, :draft, :restricted, :published, :archived])

  # to draft
  # to published
  # to restricted
  # to deleted
  # to archived
  # clear

  # STATE MACHINE
  scope :published,   where(:state => :published)  
  scope :draft,       where(:state => :draft)
  scope :restricted,  where(:state => :restricted) 
  scope :deleted,     where(:state => :deleted)
  scope :unsafe,      where(:state => :unsafe)
  scope :archived,    where(:state => :archived)

  scope :moderation_safe,    where(:moderation_state => :safe)
  scope :moderation_unsafe,  where(:moderation_state => :unsafe)
  scope :moderation_blocked, where(:moderation_state => :blocked)

  state_machine :state, :initial => :draft do
    event :to_draft do
      transition all => :draft
    end
    event :to_published do
      transition all => :published
    end
    event :to_restricted do 
      transition all => :restricted
    end
    event :to_archived do 
      transition all => :archived
    end
    event :to_deleted do 
      transition all => :deleted
    end
    event :to_unsafe do 
      transition all => :unsafe
    end
    event :clear do
      transition all => :draft
    end
    # CALLBACKS for paranoid deleting
    # move element from any nested level to root
    # it should protect tree of wrong beheavor when elements moving up/down
    # nested set - move to right
    # reversed nested set - move to left
    after_transition any => :deleted do |pub|
      root = pub.user.publications.root
      pub.move_to_left_of(root) unless pub == root
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
    # owner info
    owner = self.user
    self.user_zip= owner.zip
    self.user_login= owner.login
    # forming inline tags
    self.tags_inline= self.tag_list.to_s
    # set scoped tags
    self.set_tag_list_on(:publications, self.tag_list)

    PreviewController::basic_parser(self,
      [:textile_content,  :textile_annotation],
      [:html_content,     :html_annotation]
    )
  end#prepare_content

end

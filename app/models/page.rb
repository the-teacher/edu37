class Page < ActiveRecord::Base
  def to_param
    self.zip
  end
  
  belongs_to :user  
  acts_as_taggable
  acts_as_nested_set :scope=>:user

  has_many  :votes, :as=>:object
  has_many  :comments, :as=>:object
  has_many  :uploaded_files, :as=>:storage

=begin
  define_index do
    indexes :title
    indexes :html_content
    set_property :delta => true # true, :datetime, :delayed
  end
=end
  
  validates_presence_of :title,       :message=>I18n.translate('pages.persence.title')
  # validates_presence_of :tag_list,    :message=>I18n.translate('pages.persence.tag_list')

  scope :nested_set,          order('lft ASC')
  scope :reversed_nested_set, order('lft DESC')

  scope :published,   where(:state => :published)
  scope :draft,       where(:state => :draft)
  scope :blocked,     where(:state => :blocked) 
  scope :restricted,  where(:state => :restricted) 
  scope :deleted,     where(:state => :deleted)
  scope :archived,    where(:state => :archived)

  scope :all_states
  scope :for_index,   where(:state => [:restricted, :published])
  scope :for_manage,  where(:state => [:unsafe, :draft, :restricted, :published])

  # to draft
  # to published
  # to restricted
  # to deleted
  # to archived
  # clear

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

    # paranoid delete callback
    after_transition any => :deleted do |page|
      root = page.user.pages.root
      page.move_to_right_of(root) unless page == root
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
    self.set_tag_list_on(:pages, self.tag_list)

    PreviewController::basic_parser(self, [:textile_content], [:html_content])
  end#prepare_content

end

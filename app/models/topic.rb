class Topic < ActiveRecord::Base
  def to_param
    self.zip
  end
  
  belongs_to :user
  belongs_to :forum
  acts_as_nested_set :scope=>:user

  acts_as_taggable
  has_many  :votes,    :as=>:object
  has_many  :comments, :as=>:object

  validates_presence_of :forum_id,  :message=>'Forum id'
  validates_presence_of :title,     :message=>'Title'

  # STATE MACHINE
  scope :draft,       where(:state => :draft)
  scope :unsafe,      where(:state => :unsafe)
  scope :deleted,     where(:state => :deleted)
  scope :archived,    where(:state => :archived)
  scope :published,   where(:state => :published)
  scope :restricted,  where(:state => :restricted)

  scope :moderation_safe,    where(:moderation_state => :safe)
  scope :moderation_unsafe,  where(:moderation_state => :unsafe)
  scope :moderation_blocked, where(:moderation_state => :blocked)

  scope :for_index,       where(:state => [:unsafe, :restricted, :published])
  scope :for_manage,      where(:state => [:unsafe, :draft, :restricted, :published])
  scope :for_moderation,  where(:state => [:unsafe, :draft, :restricted, :published, :archived])

  state_machine :state, :initial => :unsafe do
    event :to_published do
      transition all => :published
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

  # BEFORE VALIDATION FILTER
  before_validation(:on => :create) do
    forming_forum_data
    forming_user_data
  end

  def forming_forum_data
    forum= self.forum
    self.forum_zip= forum.zip
    self.forum_title= forum.title
  end

  def forming_user_data
    user= self.forum.user
    self.user_id= user.id
    self.user_zip= user.zip
    self.user_login= user.login
  end

  # AFTER SAVE FILTER
  after_save do 
    forming_last_comment_data
    forming_data_for_forum    
  end

  def forming_last_comment_data
    last_comment= self.comments.last
    if last_comment
      unless (self.last_comment_id == last_comment.id)
        last_comment_user= last_comment.user
        if last_comment_user
          self.last_comment_user_id=    last_comment_user.id
          self.last_comment_user_zip=   last_comment_user.zip
          self.last_comment_user_login= last_comment_user.login
        else
          self.last_comment_user_id=    nil
          self.last_comment_user_zip=   nil
          self.last_comment_user_login= nil
        end#if
        self.last_comment_id=   last_comment.id
        self.last_comment_zip=  last_comment.zip
        self.save(:validate=>false)
      end#unless
    end#if last_comment
  end

  def forming_data_for_forum
    forum= self.forum
    # set last topic info
    forum.last_topic_id=    self.id
    forum.last_topic_zip=   self.zip
    forum.last_topic_title= self.title
    # set last comment info
    forum.last_comment_id=  self.last_comment_id
    forum.last_comment_zip= self.last_comment_zip
    # set last comment user info
    forum.last_comment_user_id=    self.last_comment_user_id
    forum.last_comment_user_zip=   self.last_comment_user_zip
    forum.last_comment_user_login= self.last_comment_user_login
    # Comments count for all published topics
    topics= forum.topics.for_index.all(:select=>[:comments_count])
    forum_comments_count= 0
    topics.each{|topic| forum_comments_count += topic.comments_count}
    forum.comments_count= forum_comments_count
    # Count of topics
    forum.topics_count= forum.topics.count
    # save
    forum.save(:validate=>false)
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
    self.set_tag_list_on(:topics, self.tag_list)

    PreviewController::basic_parser(self, [:textile_content], [:html_content])
  end

end

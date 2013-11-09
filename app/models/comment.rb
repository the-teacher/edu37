class Comment < ActiveRecord::Base
  include SimpleCaptcha::ModelValidation

  def to_param
    self.zip
  end

  belongs_to :user,   :foreign_key=>:sender_user_id
  belongs_to :object, :polymorphic =>true
  has_many  :votes,   :as=>:object

  validates_captcha :on => :create, :message=>I18n.translate('base.invalid_captcha'), :unless => lambda { Rails.env.development? }
  validates_presence_of :html_content, :message=>I18n.translate('comments.model.validator.html_content_blank')

  # for array of objects
  scope :unsafe,          where(:state => :unsafe)
  scope :safe,            where(:state => :safe)
  scope :undesirable,     where(:state => :undesirable)
  scope :blocked,         where(:state => :blocked)
  scope :deleted,         where(:state => :deleted)
  scope :published,       where(:state => [:unsafe, :safe, :undesirable])
  scope :except_deleted,  where(:state => [:unsafe, :safe, :undesirable, :blocked])

  # for object
  # unsafe - can see only poster by cookies[:view_token]
  # undesirable - can see everybody, but only after click link to_show
  # blocked - can see only sender at user_cabinet and administrator, and do nothing with it
  # deleted - can see only administrator
  state_machine :state, :initial => :unsafe do
    event :publicate do
      transition all => :safe
    end
    event :to_undesirables do
      transition all => :undesirable
    end
    event :to_blocked do
      transition all => :blocked
    end
    event :to_deleted do
      transition all => :deleted
    end
    event :clear do
      transition all => :unsafe
    end
  end

  def init(opts= {})
    return nil unless opts[:object]
    self.object= opts[:object]
    self.object_zip= opts[:object].zip

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

  after_create      :calculate_published_comments_count
  # TODO: bug => before_destroy    :calculate_published_comments_count
  before_validation :prepare_html_content
  before_create     :prepare_recipient_user

  def prepare_recipient_user
    user= object.user if object.respond_to? :user
    user= object      if object.is_a? User      
    if user
      self.user_id=   user.id
      self.user_zip=  user.zip
      self.user_login=user.login
    end
  end

  def prepare_html_content
    self.html_content = self.textile_content
  end

  def calculate_published_comments_count
    obj = self.object
    obj.comments_count= obj.comments.published.count
    obj.save(:validate=>false)
  end

  def show_on_local_machine? cookies
    return false if self.view_token.blank?
    view_token = Project::VIEW_TOKEN
    self.view_token == cookies[view_token]
  end

end

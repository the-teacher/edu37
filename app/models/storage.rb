class Storage < ActiveRecord::Base
  def to_param
    self.zip
  end
  
  belongs_to :user  
  acts_as_taggable
  acts_as_nested_set :scope=>:user
  has_many  :comments, :as=>:object
  has_many  :uploaded_files, :as=>:storage

  validates_presence_of :title, :message=>I18n.translate('storages.persence.title')
  # validates_presence_of :tag_list,  :message=>I18n.translate('storages.persence.tag_list')

  # STATES
  scope :fresh,               order('created_at DESC')
  scope :oldest,              order('created_at ASC')
  scope :nested_set,          order('lft ASC')
  scope :reversed_nested_set, order('lft DESC')

  scope :for_index,       where(:state => [:restricted, :published])
  scope :for_manage,      where(:state => [:unsafe, :personal, :restricted, :published])
  scope :for_moderation,  where(:state => [:unsafe, :restricted, :published, :archived])

  # to personal
  # to published
  # to restricted
  # to deleted
  # to archived
  # clear

  # STATE MACHINE
  scope :active,      where(:state => [:unsafe, :personal, :published, :restricted, :archived])
  scope :unsafe,      where(:state => :unsafe)
  scope :personal,    where(:state => :personal)
  scope :published,   where(:state => :published)
  scope :restricted,  where(:state => :restricted) 
  scope :archived,    where(:state => :archived)
  scope :deleted,     where(:state => :deleted)

  scope :moderation_safe,    where(:moderation_state => :safe)
  scope :moderation_unsafe,  where(:moderation_state => :unsafe)
  scope :moderation_blocked, where(:moderation_state => :blocked)

  state_machine :state, :initial => :personal do
    event :to_published do
      transition all => :published
    end
    event :to_personal do
      transition all => :personal
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
    # CALLBACKS for paranoid deleting
    # move element from any nested level to root
    # it should protect tree of wrong beheavor when elements moving up/down
    after_transition any => :deleted do |storage, transition|
      root = storage.user.storages.root
      storage.move_to_left_of(root) unless storage == root
    end

    after_transition any => :deleted do |storage|
      storage.recalculate_files_data_for_user
    end
    after_transition :deleted => any do |storage|
      storage.recalculate_files_data_for_user
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

  # FILTERS
  before_destroy :recalculate_files_data_for_user
  after_update   :recalculate_files_data_for_user

  def recalculate_files_data_for_user
    # TODO: refactor to 1 query
    user= self.user
    storages = user.storages.active

    files_size = 0
    files_count = 0
    storages.each do |s|
      files_size += s.files_size
      files_count += s.files_count
    end

    user.files_size = files_size
    user.files_count = files_count

    user.save(:validation=>false)
  end
end

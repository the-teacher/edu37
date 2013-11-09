class Profile < ActiveRecord::Base
  belongs_to :user
  acts_as_taggable
  has_many  :votes, :as=>:object
  has_many  :comments, :as=>:object
  has_many  :uploaded_files, :as=>:storage

  # STATE MACHINE
  scope :published,   where(:state => :published)  
  scope :restricted,  where(:state => :restricted) 

  scope :moderation_safe,    where(:moderation_state => :safe)
  scope :moderation_unsafe,  where(:moderation_state => :unsafe)
  scope :moderation_blocked, where(:moderation_state => :blocked)

  state_machine :state, :initial => :published do
    event :to_published do
      transition all => :published
    end
    event :to_restricted do 
      transition all => :restricted
    end
    event :clear do
      transition all => :restricted
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

  before_save :prepare_content

  def prepare_content
    # forming inline tags
    self.tags_inline= self.tag_list.to_s
    # set scoped tags
    self.set_tag_list_on(:profiles, self.tag_list)

    PreviewController::basic_parser(self, [:textile_content], [:html_content])
  end#prepare_content

end

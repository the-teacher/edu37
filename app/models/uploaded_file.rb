class UploadedFile < ActiveRecord::Base
  belongs_to :user
  acts_as_nested_set :scope=>:user
  belongs_to :storage, :polymorphic=>true

  def to_param
    self.zip
  end

=begin
  define_index do
    indexes :title
    set_property :delta => :datetime # true, :datetime, :delayed
  end
=end

  has_attached_file :file,
                    :url => Project::FILE_URL,
                    :default_url=>Project::FILE_DEFAULT,
                    :styles => { :small=> '100x100#', :mini=>  '50x50#' },
                    :convert_options => { :all => "-strip" }

  validates :title, :presence => {:message => I18n.translate('uploaded_files.persence.title')}
  validates :file_file_name, :uniqueness => {:message => I18n.translate('uploaded_files.uniqueness.file_name'), :scope=>:user_id}
  validates_attachment_size :file, :in => 1.kilobytes..2.megabytes, :message=>I18n.translate('uploaded_files.attachment_size')

  # SCOPES
  scope :nested_set,          order('lft ASC')
  scope :reversed_nested_set, order('lft DESC')

  scope :active,  where(:state => [:unsafe, :published])  
  scope :deleted, where(:state => :deleted)

  # STATE MACHINE
  scope :unsafe,      where(:state => :unsafe)
  scope :published,   where(:state => :published)
  scope :archived,    where(:state => :archived)
  scope :deleted,     where(:state => :deleted)

  scope :moderation_safe,    where(:moderation_state => :safe)
  scope :moderation_unsafe,  where(:moderation_state => :unsafe)
  scope :moderation_blocked, where(:moderation_state => :blocked)

  state_machine :state, :initial => :unsafe do
    # state machine actions
    event :to_unsafe do 
      transition all => :unsafe
    end
    event :to_published do
      transition all => :published
    end
    event :to_archived do 
      transition all => :archived
    end
    event :to_deleted do 
      transition all => :deleted
    end
    event :clear do
      transition all => :unsafe
    end
    # recalculate &
    # paranoid delete
    # nested set - move to right
    # reversed nested set - move to left
    after_transition any => :deleted do |uploaded_file|
      uploaded_file.recalculate_files_data_for_storage
      root = uploaded_file.user.uploaded_files.root
      uploaded_file.move_to_left_of(root) unless uploaded_file == root
    end
    after_transition [:unsafe, :deleted] => :published do |file|
      file.recalculate_files_data_for_storage
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
  before_validation :generate_file_name
  after_create      :recalculate_files_data_for_storage
  before_destroy    :recalculate_files_data_for_storage

  def generate_file_name
    file_name=  self.title
    self.title= self.file_title_filter(self.title)
    extension=  File.extname(self.base_file_name).downcase
    file_name=  self.file_name_filter(file_name)
    self.file.instance_write(:file_name, "#{file_name}#{extension}")
  end

  def recalculate_files_data_for_storage
    # TODO: refactor to 1 query
    storage = self.storage
    files = storage.uploaded_files.active

    sum = 0
    files.each{ |f| sum += f.file_file_size }

    storage.files_size = sum
    storage.files_count = files.size

    storage.save(:validation=>false)
  end

  # functions for FILTERS
  # Russian.translit(' _ Иван _  Иванов  ^@#$&№%*«»!?.,:;{}()<>_+|/~ Test     ----').text_symbols2dash.underscore2dash.spaces2dash.strip_dashes.downcase
  # => "ivan-ivanov-test"
  def file_name_filter file_name
    return Russian.translit(file_name).text_symbols2dash.remove_quotes.underscore2dash.spaces2dash.strip_dashes.downcase
  end

  # '«Олимпиада для школьников» и новый год + снегурочка & Dead Moро$O;ff!!!'.text_symbols2dash.spaces2dash.strip_dashes.dashes2space
  # => "Олимпиада для школьников и новый год снегурочка Dead Moро O ff"
  def file_title_filter title
    return title.text_symbols2dash.remove_quotes.spaces2dash.strip_dashes.dashes2space
  end

  # HELPERS
  def full_filepath
    Project::ADDRESS + self.file.url.split('?').first
  end

  def to_textile_link
    "\"#{self.title}\":#{self.full_filepath}"
  end

  # FILE INFO METHODS
  def base_file_name
    self.file_file_name.to_s
  end

  def base_file_type
    self.file.content_type
  end

  # FILE TYPES METHODS
  def is_image?
    ['.gif','.jpeg','.jpg','.pjpeg','.png','.bmp'].include?(File.extname(base_file_name))
  end
  
  def need_thumb?
    is_image?
  end
  
  def is_doc?
    ['.doc', '.docx'].include?(File.extname(base_file_name))
  end
  
  def is_txt?
    ['text/plain'].include?(base_file_type)
  end
  
  def is_ppt?
    ['application/vnd.ms-powerpoint', 'application/x-ppt'].include?(base_file_type)
  end
  
  def is_xls?
    ['application/vnd.ms-excel'].include?(base_file_type)
  end
  
  def is_pdf?
    ['application/pdf'].include?(base_file_type)
  end  
  
  def is_psd?
    ['.psd'].include?(File.extname(base_file_name))
  end
  
  def is_media?
    ['video/x-msvideo','audio/wav','application/x-wmf','video/mpeg','audio/mpeg','audio/mp3'].include?(base_file_type)
  end
  
  def is_arch?
    ['.zip','.rar','.gz','.tar'].include?(File.extname(base_file_name))
  end

end

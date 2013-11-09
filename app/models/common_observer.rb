class CommonObserver < ActiveRecord::Observer
  observe :user, :role, :page, :graph, :publication, :comment, :storage, :uploaded_file, :forum, :topic
  def before_validation(object)
    return unless object.zip.blank?
    prefix= 'zip'
    prefix= 'u'   if object.is_a?(User)
    prefix= 'r'   if object.is_a?(Role)    
    prefix= 'p'   if object.is_a?(Page)
    prefix= 'fm'  if object.is_a?(Forum)
    prefix= 't'   if object.is_a?(Topic)
    prefix= 'g'   if object.is_a?(Graph)
    prefix= 'pre' if object.is_a?(Prereg)
    prefix= 'c'   if object.is_a?(Comment)
    prefix= 's'   if object.is_a?(Storage)
    prefix= 'n'   if object.is_a?(Publication)
    prefix= 'f'   if object.is_a?(UploadedFile)
    zip= [prefix, rand(99999)].join
    while object.class.to_s.camelize.constantize.find_by_zip(zip)
      zip= [prefix, rand(99999)].join
    end
    object.zip= zip
  end

  def before_save(object)
    # friendly URL forming
    return unless ['Page', 'Publication', 'Forum', 'Topic', 'Storage', 'UploadedFile'].include?(object.class.to_s)
    title = Russian.translit(object.title).text_symbols2dash.remove_quotes.underscore2dash.spaces2dash.strip_dashes.downcase
    object.friendly_url = object.zip + '---' + title
  end
end

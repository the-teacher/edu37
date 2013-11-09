module Paperclip
  module Interpolations
    def login attachment, style
      attachment.instance.login
    end
    
    def holder_login attachment, style
      attachment.instance.user.login
    end

    def zip attachment, style
      attachment.instance.zip
    end
  end
end

Paperclip::Attachment.class_eval do
  def post_process_styles_with_validation
    return unless instance.need_thumb? rescue nil
    post_process_styles_without_validation
  end
  alias_method_chain :post_process_styles, :validation
end

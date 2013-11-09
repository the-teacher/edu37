module CommentsHelper

  def comment_block_for(obj)
    render(:partial=>'comments/block', :locals => {:object=>obj, :comment => @comment, :comments=>@comments})
  end

  def comment_for(type)
    case type
      when 'Publication' then t('comments.for.publication')
      when 'Page'   then t('comments.for.page')
      when 'User'   then t('comments.for.user')
      when 'Topic'  then t('comments.for.topic')
      else '?'
    end
  end#fn

  def link_to_commented_object type, id
    case type
      when 'Publication' then news_url(id)
      when 'Page'   then page_url(id)
      when 'User'   then user_url(id)
      when 'Topic'  then topic_url(id)
      else '?'
    end
  end

  def commentator_name comment
    s = ''
    if comment.creator_id
      s << link_to(comment.creator_login, user_url(comment.creator_zip))      
    else
      s << link_to(t('comments.from.guest'), '#')
    end
    raw(s << ' ')
  end#fn

end

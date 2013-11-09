module ForumsHelper

  def forum_informer forum
    str = ''
    str<< show_topic_count_for(forum)
    str<< raw('&nbsp;'*3)
    str<< show_comments_count_for(forum)
    str<< raw('&nbsp;'*3)
    str<< show_views_count_for(forum)
    str<< raw('&nbsp;'*3)
    str<< show_votes_block_for(forum)
    raw str
  end
  
  def forum_last_comment forum
    return 'Еще нет сообщений' if forum.comments_count.zero?

    str = ''
    str<< 'Последнее '
    str<< link_to('сообщение', topic_url(forum.last_topic_zip, :anchor=>forum.last_comment_zip))
    str<< ' от '
    if forum.last_comment_user_login
      str<< link_to(forum.last_comment_user_login, profiles_url(:subdomain=>forum.last_comment_user_login))
    else
      str<< 'неизвестного пользователя '
      str<< 'в&nbsp;теме '
      str<<  link_to(forum.last_topic_title, topic_url(forum.last_topic_zip))
    end
    raw str
  end

end

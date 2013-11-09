module TopicsHelper

  def topic_informer topic
    str = ''
    str<< show_comments_count_for(topic)
    str<< raw('&nbsp;'*3)
    str<< show_views_count_for(topic)
    str<< raw('&nbsp;'*3)
    str<< show_votes_block_for(topic)
    raw str
  end

  def topic_last_comment topic
    return 'Еще нет сообщений' if topic.comments_count.zero?
    
    str = ''
    str<< 'Последнее '
    str<< (link_to 'сообщение', topic_url(topic, :anchor=>topic.last_comment_zip))
    str<< ' от '
    if topic.last_comment_user_login
      str<< link_to(topic.last_comment_user_login, profiles_url(:subdomain=>topic.last_comment_user_login))
    else
      str<< 'неизвестного пользователя '
      str<< topic.updated_at.strftime("%H:%M&nbsp;%d-%m-%Y")
    end
    raw str
  end

end

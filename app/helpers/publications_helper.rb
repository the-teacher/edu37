module PublicationsHelper
  def news_informer publication
    str = ''
    str<< show_comments_count_for(publication)
    str<< raw('&nbsp;'*3)
    str<< show_views_count_for(publication)
    str<< raw('&nbsp;'*3)
    str<< show_votes_block_for(publication)
    raw str
  end
end

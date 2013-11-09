module TagsHelper

  def forming_tag tag
    img = image_tag("modern/mini-icons/tag_#{[:blue, :red, :yellow, :purple, :green, :orange].rand.to_s}.png", :alt=>tag) << " "
    content_tag(:span, link_to(img+tag, tag_news_index_url(:word=>tag)), :class=>:nobr) << " "
  end

  def tags_block(object)
    s = ''
    object.tags_inline.split(', ').each do |tag|
      s << forming_tag(tag)
    end
    raw s
  end
  
  def tag_cloud_for(klass)
    s = ''
    @tags= klass.to_s.singularize.camelcase.constantize.tag_counts_on(klass).all(:limit=>12, :order=>'count DESC').shuffle
    tag_cloud(@tags, %w(mini small normal big)) do |tag, css_class|
      s << content_tag(:span, forming_tag(tag.name), :class=>css_class)
    end
    raw s
  end
end

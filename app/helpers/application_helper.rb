module ApplicationHelper
  # create DOM object id with my wishes
  def object_id(object, prefix= nil)
    str = ''
    str += "#{prefix.to_s}_" if prefix
    str += "#{object.class.to_s.downcase}_#{object.to_param}"
    str
  end

  # custom error messages of object
  def object_errors(object)
    # get @object variable from :object || @object
    object = instance_variable_get("@#{object}") unless object.respond_to?(:to_model)
    return unless object
    return unless object.errors.any?
    res = ''
    object.errors.each do |name, value|
      # example: activerecord.attributes.user.login
      res += content_tag(:li, t("activerecord.attributes.#{object.class.to_s.pluralize.downcase}.#{name}") + value)
    end
    res= content_tag :ul, raw(res)
    header= object.errors.size > 1 ? t('object_errors.errors.many') : t('object_errors.errors.one')
    res= content_tag(:h3, header) + res
    res= content_tag :div, res, :class=>:error
    res= content_tag :div, res, :class=>:system_messages
  end#object_errors(object)

  # custom flash messages for APP
  def app_flash(flash)
    return unless flash.is_a?(Hash) 

    res= ''
    [:notice, :warning, :error].each do |section|
      if flash[section]
        flash_= ''
        section_id = "#{section}_messages"
        
        flash_= content_tag(:li, flash[section])
        flash_= content_tag :ul, flash_
        flash_= content_tag(:h3, t("flash.#{section.to_s}.title")) + flash_
        flash_= content_tag :div, flash_, :class=>section
        flash_= content_tag :div, flash_, :class=>:system_messages, :id=>section_id
        
        js_code = <<-JS
          $(document).ready(function() {
            // $('##{section_id}').show().delay(5000).hide();
          });
        JS

        flash_ += javascript_tag(js_code, :defer=>:defer)

        flash[section]= nil
        res+= flash_
      end
    end
    res
  end #app_flash

  def popup_window(options={})
    opts={
      :name=>:window,
      :width=>800,
      :height=>600,
      :top=>0,
      :left=>0,
      :toolbar=>1,
      :location=>1,
      :directories=>1,
      :menubar=>1,
      :scrollbars=>1,
      :resizable=>1,
      :status=>1,
      :fullscreen=>0
    }.merge!(options)
    name= opts.delete(:name)

    _opts= []
    opts.each_pair do |key, value|
      _opts.push [key, value].join('=')
    end
    _opts = _opts.join(',')

    "window.open(this.href,'#{name}','#{_opts}')"
  end#popup_window

  # BORDER ROUNDER
  def top_bordered_rounder
    raw "<div class='b_rounder top'><i>&nbsp;</i><b>&nbsp;</b></div>\n"
  end
  def bottom_bordered_rounder
    raw "<div class='b_rounder bottom'><i>&nbsp;</i><b>&nbsp;</b></div>\n"
  end
  def bordered_rounder content
    str=  bordered_rounder_top
    str+= content_tag :div, content, :class=>:rounded_content
    str+= bordered_rounder_bottom
    raw str
  end
  # ~BORDER ROUNDER

  # ROUNDER
  def top_rounder
    raw "<div class='rounder top'><i>&nbsp;</i><b>&nbsp;</b></div>\n"
  end
  def bottom_rounder
    raw "<div class='rounder bottom'><i>&nbsp;</i><b>&nbsp;</b></div>\n"
  end
  def rounder content
    str=  rounder_top
    str+= content_tag :div, content, :class=>:rounded_content
    str+= rounder_bottom
    raw str
  end
  # ~ROUNDER


  # COMMON INFO ELEMENTS
  def show_views_count_for object
    str= ''
    str << image_tag('modern/mini-icons/eye.png', :alt=>t('shared.show_count'), :title=>t('shared.show_count'))
    str << '&nbsp;'
    str << object.show_count.to_s
    raw str
  end

  def show_comments_count_for object
    str= ''
    str << image_tag('modern/mini-icons/comment.png', :alt=>t('shared.comments_count'), :title=>t('shared.comments_count'))
    str << '&nbsp;'
    str << object.comments_count.to_s
    raw str
  end

  def show_topic_count_for object
    str= ''
    str << image_tag('modern/mini-icons/topics.png', :alt=>t('shared.topics_count'), :title=>t('shared.topics_count'))
    str << '&nbsp;'
    str << object.topics_count.to_s
    raw str
  end

  # COMMON STATE
  def state_icon(object)
    return '' if object.new_record?
    case
      when object.respond_to?('unsafe?') && object.unsafe?
        then image_tag 'modern/icons/unsafe.png', :alt=>t('states.unsafe'), :title=>t('states.unsafe')
      when object.respond_to?(:to_draft) && object.draft?
        then image_tag 'modern/icons/draft.png', :alt=>t('states.draft'), :title=>t('states.draft')
      when object.respond_to?(:to_restricted) && object.restricted?
        then image_tag 'modern/icons/restricted.png',:alt=>t('states.restricted'), :title=>t('states.restricted')
      when object.respond_to?(:to_personal) && object.personal?
        then image_tag 'modern/icons/restricted.png',:alt=>t('states.restricted'), :title=>t('states.personal')
      when object.respond_to?(:to_published) && object.published?
        then image_tag 'modern/icons/published.png', :alt=>t('states.published'), :title=>t('states.published')
      when object.respond_to?('archived?') && object.archived? then 
        image_tag 'modern/icons/archived.png', :alt=>t('states.archived'), :title=>t('states.archived')
      when object.respond_to?('deleted?') && object.deleted? then 
        image_tag 'modern/icons/deleted.png', :alt=>t('states.deleted'), :title=>t('states.deleted')
      else
        image_tag 'modern/icons/unsafe.png', :alt=>t('states.unsafe'), :title=>t('states.unsafe')
    end#case
  end#fn

  def moderation_state_icon(object)
    return '' if object.new_record?
    case
      when object.respond_to?('moderation_safe?') && object.moderation_safe? then
        image_tag 'modern/icons/moderation_safe.png', :alt=>t('moderation_states.moderation_safe'), :title=>t('moderation_states.moderation_safe')
      when object.respond_to?('moderation_unsafe?') && object.moderation_unsafe? then
        image_tag 'modern/icons/moderation_unsafe.png', :alt=>t('moderation_states.moderation_unsafe'), :title=>t('moderation_states.moderation_unsafe')
      when object.respond_to?('moderation_blocked?') && object.moderation_blocked? then
        image_tag 'modern/icons/moderation_blocked.png', :alt=>t('moderation_states.moderation_blocked'), :title=>t('moderation_states.moderation_blocked')
      else
        image_tag 'modern/icons/moderation_unsafe.png', :alt=>t('moderation_states.moderation_unsafe'), :title=>t('moderation_states.moderation_unsafe')
    end#case
  end#fn

  def moderation_buttons_for(o)
    s = ''
    unless o.new_record?
      if current_user.top_manager?
        if o.respond_to?('moderation_blocked?') && !o.moderation_blocked? then
          s += submit_tag t('buttons.to_blocked_moderation'), :name=>:to_blocked_moderation,  :confirm=>t('confirms.to_blocked_moderation')
        end;if o.respond_to?('moderation_safe?') && !o.moderation_safe? then
          s += submit_tag t('buttons.to_safe_moderation'),    :name=>:to_safe_moderation,     :confirm=>t('confirms.to_safe_moderation')
        end;if o.respond_to?('moderation_unsafe?') && !o.moderation_unsafe? then
          s += submit_tag t('buttons.to_unsafe_moderation'),  :name=>:to_unsafe_moderation,   :confirm=>t('confirms.to_unsafe_moderation')
        end
      end#if
    end#new_record?
    s= content_tag(:div, raw(s), :class=>:moderation_buttons) unless s.blank?
    s
  end#fn

  def preview_button
    button_to_function(t('buttons.preview'), "preview()", :name=>:preview_button)
  end

  def form_buttons_for(object)
    s = ''
    unless object.new_record?
      if object.respond_to?('draft?')
        s<< submit_tag(t('buttons.to_draft'), :name=>:to_draft, :confirm=>t('confirms.to_draft')) unless object.draft?
      end
      if object.respond_to?('published?')
        s<< submit_tag(t('buttons.to_published'), :name=>:to_published,   :confirm=>t('confirms.to_published')) unless object.published?
      end
      if object.respond_to?('restricted?')
        if current_user.has_role? :form_buttons, :advanced_states
          s<< submit_tag(t('buttons.to_restricted'),  :name=>:to_restricted,:confirm=>t('confirms.to_restricted')) unless object.restricted?
        end
      end
      if object.respond_to?('archived?')
        if current_user.has_role? :form_buttons, :advanced_states
          s<< submit_tag(t('buttons.to_archived'),  :name=>:to_archived,    :confirm=>t('confirms.to_archived'))   unless object.archived?
        end
      end
    end#new_object?
    content_tag :div, raw(s), :class=>:publication_buttons
  end#fn

  def get_js_from_yaml(objects)
    arr = []
    objects.each do |obj|
      if obj.js_addons.is_a?(String)
        js = YAML::load(obj.js_addons)
        js.each do |elem|
          arr.push elem
        end
      end
    end
    arr.uniq 
  end#fn

  def get_css_from_yaml(objects)
    arr = []
    objects.each do |obj|
      if obj.css_addons.is_a?(String)
        css = YAML::load(obj.css_addons)
        css.each do |elem|
          arr.push elem
        end
      end
    end
    arr.uniq
  end#fn

  def read_more_link(item, url)
    unless item.html_content.blank?
      link_to raw(t('shared.read_more')), send(url, item)
    else
      link_to raw(t('shared.to_comments')), send(url, item, {:anchor=>:comments})
    end
  end

  def state_icon_for_manage(node)
    state_icon = ''
    if node.respond_to?(:to_draft) && node.draft?
      text= t('states.draft')
      state_icon= image_tag('modern/mini-icons/draft.png', :alt=>text, :title=>text)
    elsif node.published?
      text= t('states.published')
      state_icon= image_tag('modern/mini-icons/publiched.png', :alt=>text, :title=>text)
    elsif node.blocked?
      text= t('states.blocked')
      state_icon= image_tag('modern/mini-icons/blocked.png', :alt=>text, :title=>text)
    elsif node.archived?
      text= t('states.archived')
      state_icon= image_tag('modern/mini-icons/archived.png', :alt=>text, :title=>text)
    elsif node.restricted?
      text= t('states.restricted')
      state_icon= image_tag('modern/mini-icons/restricted.png', :alt=>text, :title=>text)
    elsif node.unsafe?
      text= t('states.unsafe')
      state_icon= image_tag('modern/mini-icons/unsafe.png', :alt=>text, :title=>text)
    end
    raw(state_icon + raw('&nbsp;'))
  end#fn

  def state_icon_for_controls_for(node)
    case
      when node.unsafe? then
        content_tag :span, '', :class=>'button unsafe', :title=>t('states.unsafe')
      when node.respond_to?('draft?') && node.draft? then
        content_tag :span, '', :class=>'button draft', :title=>t('states.draft')
      when node.respond_to?('published?') && node.published? then
        content_tag :span, '', :class=>'button published', :title=>t('states.published')
      when node.respond_to?('restricted?') && node.restricted? then
        content_tag :span, '', :class=>'button restricted', :title=>t('states.restricted')
      when node.respond_to?('archived?') && node.archived? then 
        content_tag :span, '', :class=>'button archived', :title=>t('states.archived')
      when node.respond_to?('deleted?') && node.deleted? then 
        content_tag :span, '', :class=>'button deleted', :title=>t('states.deleted')
      else
        content_tag :span, '', :class=>'button unsafe', :title=>t('states.unsafe')
    end#case
  end

  def moderation_state_for_controls_for(node)
    case
      when node.moderation_unsafe? then
        content_tag :span, '', :class=>'button moderation_unsafe', :title=>t('moderation_states.moderation_unsafe')
      when node.moderation_safe? then
        content_tag :span, '', :class=>'button moderation_safe', :title=>t('moderation_states.moderation_safe')
      when node.moderation_blocked?
        content_tag :span, '', :class=>'button moderation_blocked', :title=>t('moderation_states.moderation_blocked')
    end#case
  end

  # QR code
  def qr_block_to url= '#'
    content_tag(:p, image_tag("https://chart.googleapis.com/chart?chs=200x200&cht=qr&chl=#{url}&choe=UTF-8"), :class=>:qr)
  end

end

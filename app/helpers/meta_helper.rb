module MetaHelper
  def get_array_from_yaml(variable)
    return [] unless variable.is_a? String
    arr = YAML::load variable
    return [] unless arr.is_a? Array
    arr    
  end

  # forming javascript include tags from array
  # which contain JS file names
  def array_to_js_include_tags arr
    return '' if arr.blank?
    s = ''
    arr.each{ |line| s<< javascript_include_tag(line) }
    s
  end

  # forming css link include tags from array
  # which contain css file names
  def array_to_css_include_tags arr
    return '' if arr.blank?
    s = ''
    arr.each{ |line| s<< stylesheet_link_tag(line, :media=>:screen) }
    s
  end
end

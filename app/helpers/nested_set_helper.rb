module NestedSetHelper
  # Publicated by MIT
  # Awesome Nested Set View Helper
  # Ilya Zykin, zykin-ilya@ya.ru, Russia, Ivanovo 2009-2011
  # github.com/the-teacher
  #-------------------------------------------------------------------------------------------------------
  
  # =nested_set_tree(@pages)
  # =nested_set_tree(@pages, :class_name=>'Pages', :id_field=>:zip, :clean=>false, :admin=>true)

  def create_root_element_link(options= {})
    opts= {:top_root=>false}.merge!(options)
    render :partial => "#{opts[:path]}/create_root", :locals => { :opts=>opts }
  end

  def ans_controls(node, options= {})
    opts= {
      :class_name=>nil,   # class of nested elements
      :id_field=>'id',    # id field name, id by default
      :first=>false,      # first element flag
      :last=>false,       # last element flag
      :has_childs=>false  # has childs?
    }.merge!(options)
    render :partial => "#{opts[:path]}/controls", :locals => { :node=>node, :opts => opts }
  end

  def nested_set_tree(tree, options= {})
    result= ''

    opts= {
      :node=>nil,         # node
      :admin=>false,      # render admin tree?
      :root=>false,       # is it root node? 
      :id_field=>'id',    # id field name, id by default
      :class_name=>nil,   # class of nested elements
      :path => 'ans',     # default view partials path
      :first=>false,      # first element flag
      :last=>false,       # last element flag
      :level=> 0,         # recursion level
      :clean=>true        # delete element from tree after rendering. ~25% time economy when rendering tree once on a page
    }.merge!(options)

    node= opts[:node]
    root= opts[:root]

    # must be string
    opts[:id_field]= opts[:id_field].to_s
    # find class name
    opts[:class_name]= opts[:class_name] ? opts[:class_name].to_s.downcase : tree.first.class.to_s.downcase

    unless node
      roots= tree.select{|elem| elem.parent_id.nil?}
      # find ids of first and last root node
      roots_first_id= roots.empty? ? nil : roots.first.id
      roots_last_id=  roots.empty? ? nil : roots.last.id
      
      # render roots
      roots.each do |root|
        is_first= (root.id==roots_first_id)
        is_last= (root.id==roots_last_id)
        _opts = opts.merge({:node=>root, :root=>true, :level=>opts[:level].next, :first=>is_first, :last=>is_last})
        result<< nested_set_tree(tree, _opts)
      end
    else
      res= ''
      controls= ''
      childs_res= ''

      # select childs
      childs= tree.select{|elem| elem.parent_id == node.id}
      opts.merge!({:has_childs=>childs.blank?})

      # admin controls
      if opts[:admin]
        c = ans_controls(node, opts)
        controls= content_tag(:span, c, :class=>:controls)
      end

      # find id of first and last node
      childs_first_id= childs.empty? ? nil : childs.first.id
      childs_last_id=  childs.empty? ? nil : childs.last.id

      # render childs
      childs.each do |elem|
        is_first= (elem.id==childs_first_id)
        is_last= (elem.id==childs_last_id)
        _opts = opts.merge({:node=>elem, :root=>false, :level=>opts[:level].next, :first=>is_first, :last=>is_last})
        childs_res << nested_set_tree(tree, _opts)
      end

      # build views
      childs_res= childs_res.blank? ? '' : render(:partial=>"#{opts[:path]}/nested_set", :locals=>{:opts=>opts, :parent=>node, :childs=>childs_res})
      link= render(:partial=>"#{opts[:path]}/link", :locals=>{:opts=>opts, :node=>node, :root=>root, :controls=>controls})
      res= render(:partial=>"#{opts[:path]}/nested_set_item",  :locals=>{:opts=>opts, :node=>node, :link=>link, :childs=>childs_res})

      # delete current node from tree if you want
      # recursively moving by tree is 25%+ faster on 500 elems
      tree.delete(node) if opts[:clean]

      result << res
    end
    raw result
  end#nested_set_tree
end# module

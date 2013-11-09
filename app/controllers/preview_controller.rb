class PreviewController < ApplicationController

  def blank; end

  def preview
    @pub = @user.pages.new
    @pub.textile_content = params[:content][:content]

    PreviewController::basic_parser(@pub,
      [:textile_content],
      [:html_content]
    )
    
    render :layout=>'preview', :action => 'preview'
  end

  def preview_with_annotation
    @pub = @user.publications.new
    @pub.textile_annotation = params[:content][:annotation]
    @pub.textile_content = params[:content][:content]

    PreviewController::basic_parser(@pub,
      [:textile_annotation, :textile_content],
      [:html_annotation, :html_content]
    )
    
    render :layout=>'preview', :action => 'preview_with_annotation'
  end

  def self.basic_parser(object, src, dist)
    owner = object.user
    # Чистим исходник
    # Выбираем src из кодов вставок объектов
    # сами коды чистим и вместо них вставляем src
    src.each do |field|
      object[field].extract_src_from_registrated_hostings!
    end
  
    # Если владелец не обладает расширенными правами разметки,
    # то вырежем указанные теги из всего исходника
    unless owner.has_role?(:markup, :advanced)
      src.each do |field|
        object[field].blacklist! [:object, :embed, :param, :iframe]
      end
    end

    # Все языки привести к нижнему регистру
    src.each do |field|
      object[field].downcase_code_langs!
    end

    # Массив для хранения корректных и не корректных языков
    # для подсветки синтаксиса
    code_langs = {:correct=>[], :incorrect=>[]}

    # Выборка языков из всех исходных полей
    src.each do |field|
      langs = object[field].get_code_langs
      code_langs[:correct]=   code_langs[:correct]   | langs[:correct]
      code_langs[:incorrect]= code_langs[:incorrect] | langs[:incorrect]
    end

    # Удалить ошибочные теги языков программирования из исходных полей
    src.each do |field|
      object[field] = object[field].remove_incorrect_code_langs(code_langs[:incorrect])
    end

    # Если найден хоть один ошибочный язык, то добавим к корректным языкам язык - :text
    # если, он, конечно, еще не присутствует в массиве коректных языков
    # язык :text потребуется при формировании css
    code_langs[:correct].push(:text) unless code_langs[:correct].member?(:text) unless code_langs[:incorrect].blank?

    # Для всех правильных языков формируем массив css файлов и сохраняем в этом объекте
    # config/initializers/array_class_addons.rb
    object.js_addons=  code_langs[:correct].to_hightlight_js_array.to_yaml
    object.css_addons= code_langs[:correct].to_hightlight_css_array.to_yaml
    
    src.each_index do |i|
      # От рядового пользователя должна приходить только чистая разметка
      # Во всех исходных полях жестко вырежем весь HTML
      # И только после тотальной чистки начнем парсинг
      object[src[i]]= Sanitize.clean(object[src[i]], SatitizeRules::Config::TOTAL) unless owner.has_role?(:markup, :advanced)
      source = object[src[i]]
      # оформляем блоки с подсветкой кода
      # внутри блоков скобки <, > превращаются в эквиваленты
      result= source.code_blocks_parser
      # Заменяем ###bla-bla  на якоря anchor -> config/initializers/string_class_addons.rb
      result= result.sharps2anchor
      # заменяем url хостингов на плееры, обернутые в <notextile>
      result= result.links_to_players
      # Его Величество RedCloth, он же Textile
      object[dist[i]]= RedCloth.new(result).to_html
    end
    object
  end#basic_parser
end#PreviewController

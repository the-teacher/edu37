module VotesHelper
=begin
  /*
  jQuery.ajax({
    type: "POST",
    url: url,
    data: {textile_text: $(src_id).val()},
    dataType: "html",
    success: function(data, status, xhr){
      $(dist_id).contents().find('html').html(data);
    },
    beforeSend: function(xhr){
      $(dist_id).contents().find('html').html(loading_elem);
    },
    complete: function(xhr, status){},
    error: function(xhr, status, error){
      alert(error_alert);
      $(dist_id).contents().find('html').html(error_alert);
    }
  });//jQuery.ajax
  */
=end
  def votes_js
    str= ''
    str += javascript_tag :defer => 'defer' do raw("
      function voiting(url, type, id){
        var object_vote_block_id;
        vote_block_id = '#' + 'vote_block' + '_' + type + '_' + id;
        ajax_loader_id = '#' + 'ajax_loader' + '_' + type + '_' + id;

        jQuery.ajax({
          type: 'POST',
          url: url,
          data: {object_type: type, object_id: id, authenticity_token: '#{form_authenticity_token}' },
          dataType: 'script',
          beforeSend: function(xhr){
            $(vote_block_id).hide();
            $(ajax_loader_id).show();
          },
          error: function(xhr, status, error){
            alert(error);
          }
        });//jQuery.ajax
      }

      function vote_up(object_type, object_id){
        voiting('#{up_votes_url}', object_type, object_id);
      }

      function vote_down(object_type, object_id){
        voiting('#{down_votes_url}', object_type, object_id);
      }
      ") end
    str
  end

  def vote_rating_for(object)
    return '' unless object
    plus = object.positive_value
    minus = object.negative_value
    total = (plus + minus).round
    total = 'пока отсутствует' if total <= 0
    "Рейтинг: #{total.to_s}"
  end

  def show_votes_block_for(object)
    return '' unless object

    url= up_votes_url
    obj_class= object.class.to_s.downcase
    obj_id= object.to_param

    str = ''

    raiting = content_tag(:span, '&nbsp', :id=>object_id(object, :raiting_block), :style=>'display:none;')
    loader = content_tag(:span, image_tag('modern/loader.gif', :title=>"Ожидайте", :alt=>"Ожидайте"), :id=>object_id(object, :ajax_loader), :style=>'display:none;')

    str<< 'Моё мнение '
    str<< link_to_function(image_tag('modern/mini-icons/thumb_up.png', :alt=>'Мне понравилось', :title=>'Мне понравилось'), "vote_up('#{obj_class}', '#{obj_id}')")
    str<< ' или '
    str<< link_to_function(image_tag('modern/mini-icons/thumb_down.png', :alt=>'Мне не понравилось', :title=>'Мне не понравилось'), "vote_down('#{obj_class}', '#{obj_id}')")
    str= content_tag(:span, raw(str), :id=>object_id(object, :vote_block))
    str = loader + str + raiting
    raw str
  end
end

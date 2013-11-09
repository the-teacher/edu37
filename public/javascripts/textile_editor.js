var textile_id = '#textile_content';
var html_id = '#html_content';
var help_id = '#editor_help';

function textile_editor_show(id){
  $(textile_id).hide();  
  $(html_id).hide();  
  $(help_id).hide();
  $(id).show();
}
// TEXTILE 2 HTML
function update_preview(src_id, dist_id, url){
  if(jQuery.browser.msie && (jQuery.browser.version == 6)){alert('Увы. Ничего не получится. Вы используете Internet Explorer 6.'); return false;}
  
  loading_elem = '<div class="ajax_loader"><img src="/images/basic/ajax.gif" alt="Идет загрузка данных с сервера с помощью технологии AJAX (АЯКС)" /></div>';
  error_alert = "Технология АЯКС. \nСерверная ошибка или ошибка соединения с Интернет";

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
}//update_preview

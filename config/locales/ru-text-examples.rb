=begin
  # PAGES
  
  pages:
    has_comments: 'Количество коментариев этой страницы: '
    model:
      validator:
        user_id_undefined: "Не определен идентификатор владельца страницы"
        zip_undefined: "Не определен zip-идентификатор страницы"
        title_undefined: "У страницы должен быть заголовок"
    view:
      manage: 'Управление страницами'
      pages_manage: 'Управление страницами сайта'
      create_root_element: 'Добавить здесь корневую страницу'
      update_button: 'Обновить страницу'
      create_button: 'Создать страницу'
      editing: 'название страницы'
      edit: 'Редактирование страницы'
      page_name: 'Название страницы'
      edit: 'Редактирование страницы'
      new_page_creating: 'Создание новой страницы для'
      page_is_child_of: 'Данная страница будет являться дочерней по отношению к странице:'
      create_new_page: 'Создать новую страницу'
      back_to_edit: '&laquo; Вернуться к редактированию'
      publicate: "Опубликовать"
      to_drafts: "В черновики"
      to_blocked: "Заблокировать"
    notices:
      created: 'Страница успешно создана'
      updated: 'Страница успешно обновлена'
      deleted: 'Страница безвозвратно удалена'
      up: 'Страница перемещена вверх'
      down: 'Страница перемещена вниз'
    errors:
      cant_be_move: 'Не удается переместить'
      on_create: 'Ошибка при создании страницы'
      on_updated: 'Ошибка при обновлении'
    states:
      title: 'Состояние страницы'
      publicate: "Опубликовано"
      to_drafts: "Черновик"
      to_blocked: "Заблокировано"
      clear: "Установить значение по умолчанию"
      descriptions:
        draft: "На данный момент страница находится в состоянии ЧЕРНОВИК. Это значит, что ее можно увидеть только в панеле администратора и она не видима для посетителей сайта. Перевидите страницу в состояние - ОПУБЛИКОВАНО, что бы пользователи смогли ее увидеть"
        blocked: "Сейчас эта страница ЗАБЛОКИРОВАНА. Вероятно, страницу заблокировал член административной группы сайта. Если Вы входите в административную группу, то по вашему усмотрению страницу можно разблокировать, иначе, это сделать будет невозможно. При возникновении недоразумений - обратитесь к администратраторам сайта."
        published: 'Страница ОПУБЛИКОВАНА. Сейчас она видна пользователям. Если вы хотите скрыть ее от посторонних глаз - перевидите страницу в одно из других состояний'
=end

{
  :en=>{
    :text=>{
      :sessions=>{
        :new=>{
          :welcome=>'Welcome JosephStalin.com',
          :description=>"This form for login registred user",
          :login_label=>"Login <strong>(your name in system)</strong>",
          :login=>"Login &mdash; your nic name in JosephStalin.com information system",
          :password_label=>"Password",
          :password=>"Password for enter",
          :check_requirement=>"don't set it, if it's not your computer",
          :remember_me=>"Remember me <strong>(3 days)</strong>"
        }
      }#sessions
    }#text
  }#en
}

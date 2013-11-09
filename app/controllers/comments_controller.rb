class CommentsController < ApplicationController
  before_filter :find_comment, :only=>[:show, :edit, :update, :destroy, :inplace_edit, :inplace_update, :inplace_publicate]

  def index
    @comments = Comment.all
  end

  def manage
    @comments = @user.incoming_comments.except_deleted.paginate(:page => params[:page], :per_page=>20)
  end

  def new
    @comment = Comment.new
  end

  def show; end
  def edit; end

  def update
    if @comment.update_attributes(params[:comment])
      redirect_to(manage_comments_url(:subdomain=>@user.subdomain), :notice => 'Сообщение успешно обновлено')
    else
      redirect_to(manage_comments_url(:subdomain=>@user.subdomain), :notice => 'При обновлении сообщения возникли проблемы')
    end
  end

  # INPLACE
  def inplace_edit
    render(:action=>'comments/inplace/edit', :layout => false) and return
  end

  def inplace_publicate
    @comment.publicate
    render :text=>"alert('Опубликовано');" and return #(:action=>'comments/inplace/edit', :layout => false) and return
  end

  def create
    unless ['forum', 'topic', 'page', 'publication', 'user'].include? params[:object_type]
      flash[:notice] = t('comments.commentable_object_type_error')
      redirect_back_or(root_url) and return
    end

    @object= params[:object_type].camelize.constantize.find_by_zip(params[:object_zip])

    unless @object
      flash[:notice]= t('comments.commentable_object_not_found')
      redirect_back_or(root_url) and return
    end

    # build url for redirect
    # and fix it, if url_name == publication
    # TODO: uRRRh! stupid situation
    url_name= @object.class.to_s.downcase
    url_name= 'news' if url_name == 'publication'
    url= eval("#{url_name}_url(@object)")

    # config/initializers/project.rb
    @comment= Comment.new(params[:comment]).init(:object=>@object, :user=>@user, :creator=>current_user)
    @comment.view_token= Project::get_view_token(cookies)

    if @comment.save
      flash[:notice] = t('comments.commented')
    else
      flash[:notice] = t('comments.commenting_failure')
    end
    @audited_object = @comment
    redirect_to(url) and return
  end

  def destroy
    @comment.destroy
    redirect_to(comments_url)
  end

  protected  

  def find_comment
    @comment = Comment.find_by_zip(params[:id])
    access_denied and return unless @comment
    @audited_object = @comment
  end
end

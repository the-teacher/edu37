class ForumsController < ApplicationController
  before_filter :find_forum,      :only=>[:show, :edit, :update, :destroy]
  before_filter :get_forum_state, :only=> [:update]

  def index
    @forums = @user.forums.for_index.all(:order=>"lft ASC")
  end

  def show
    @forum.increment!(:show_count)
    if logged_in?
      if current_user.has_role?(:system, :administrator)
        @topics= @forum.topics
      else current_user.has_role?(:forums, :moderator)
        @topics= @forum.topics.for_moderation
      end
    else
      @topics= @forum.topics.for_index
    end
  end

  def new
    @forum = Forum.new
  end

  def edit
    @topics = @forum.topics
  end

  def manage
    @forums= @user.forums.for_manage.all(:select=>[:id, :zip, :title, :state, :parent_id, :lft, :rgt], :order=>"lft ASC")
  end

  def create
    @forum = Forum.new(params[:forum]).init(:user=>@user, :creator=>current_user)

    if @forum.save
      @forum.to_draft if current_user.owner?(@forum)
      redirect_to(edit_forum_url(@forum, :subdomain=>@user.subdomain), :notice => 'Форум успешно создан')
    else
      render :action => "new"
    end
  end

  def update
    if @forum.update_attributes(params[:forum])
      set_forum_state
      redirect_to(edit_forum_url(@forum, :subdomain=>@user.subdomain), :notice => 'Форум успешно обновлен')
    else
      render :action => "edit"
    end
  end

  def destroy
    @forum.to_deleted
    redirect_to(manage_forums_url(:subdomain=>@user.subdomain))
  end

  protected

  def find_forum
    if action_name == 'restructure'
      @forum= @user.forums.find(params[:id].to_i)
    elsif action_name == 'show'
      zip= params[:id].split('---').first
      @forum= @user.forums.find_by_zip(zip)
    else
      @forum= @user.forums.find_by_zip(params[:id])
    end

    access_denied and return unless @forum
    @audited_object=          @forum # audition system
    @object_for_role_system=  @forum # role system
  end

  def get_forum_state
    if current_user.has_role?(:system, :administrator) || current_user.has_role?(:forums, :moderator)
      @moderation_state = :to_blocked_moderation  if params[:to_blocked_moderation]
      @moderation_state = :to_unsafe_moderation   if params[:to_unsafe_moderation]
      @moderation_state = :to_safe_moderation     if params[:to_safe_moderation]
    end
    @state = :to_restricted if params[:to_restricted]
    @state = :to_published  if params[:to_published]
    @state = :to_archived   if params[:to_archived]
    @state = :to_unsafe     if params[:to_unsafe]
    @state = :to_draft      if params[:to_draft]
    @state = :clear         if params[:clear]
  end

  def set_forum_state
    unless @moderation_state.blank?
      @forum.send(@moderation_state)  if @forum.respond_to?(@moderation_state)
    end
    unless @state.blank?      
        @forum.send(@state) if @forum.respond_to?(@state)
    end
  end

end

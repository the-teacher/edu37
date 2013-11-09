class Admin::UsersController < ApplicationController
  # login
  before_filter :login_required
  # role
  before_filter :role_require
  # finders
  before_filter :find_user, :only=>[:edit, :update, :login_as, :change_role]
  # preparators
  before_filter :get_user_state, :only=>[:update]

  # restricted area

  def index
    @users = User.fresh.all.paginate(:page=>params[:page], :per_page=>30)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      flash[:notice] = t('users.created')
      redirect_to(edit_admin_user_url(@user))
    else
      render :action => :new
    end
  end

  def edit; end

  def update
    if @user.update_attributes(params[:user])
      set_user_state
      redirect_to(edit_admin_user_url(@user, :subdomain=>false), :notice => t('users.updated'))
    else
      render :action => :edit
    end
  end
  
  def login_as
    if @user
      logout_keeping_session!
      self.current_user = @user
      handle_remember_cookie! false # just once
      redirect_to(cabinet_users_url(:subdomain=>current_user.subdomain), :notice => t('sessions.notice.logined'))
    else
      flash[:error] = t('sessions.error.wrong_login_data')
      redirect_back_or(root_path)
    end
  end

  protected

  def get_user_state
    @moderation_state = :to_blocked_moderation  if params[:to_blocked_moderation]
    @moderation_state = :to_unsafe_moderation   if params[:to_unsafe_moderation]
    @moderation_state = :to_safe_moderation     if params[:to_safe_moderation]

    @state = :to_draft      if params[:to_draft]
    @state = :to_published  if params[:to_published]
    @state = :to_restricted if params[:to_restricted]
    @state = :to_archived   if params[:to_archived]
    @state = :clear         if params[:clear]
  end

  def set_user_state
    unless @moderation_state.blank?
      @user.send(@moderation_state)  if @user.respond_to?(@moderation_state)
    end
    unless @state.blank?
      @user.send(@state) if @user.respond_to?(@state)
    end
  end

  def find_user
    @user= User.find_by_zip(params[:id])
    @audited_object=          @user # audition system
    @object_for_role_system=  @user # role system
  end

  # Role system for admin controllers
  def role_require
    admin_or_moderator = current_user.has_role?(:system, :administrator) || current_user.has_role?(:moderator, controller_name)
    access_denied unless current_user.has_role?(controller_name, action_name) || admin_or_moderator
  end

end

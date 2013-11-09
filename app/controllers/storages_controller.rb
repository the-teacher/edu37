class StoragesController < ApplicationController
  # login
  before_filter :login_required, :except=> [:index, :show, :tag]
  # finders
  before_filter :find_storage, :only=>[:show, :edit, :update, :rebuild, :destroy]
  # role system
  before_filter :role_require, :except=>[:index, :show, :tag]
  before_filter :owner_and_role_require, :only=>[:edit, :update, :rebuild, :destroy]  
  # preparators
  before_filter :get_storage_state, :only=> [:update]
  before_filter :prepare_tag_list, :only=>[:create, :update]
  # fixers
  before_filter :fix_url_by_redirect, :only=>[:show]
  before_filter :protect_from_crossdomain_sniffers, :only=>[:manage]
  
  def index
    @storages= @user.storages.for_index.fresh.all.paginate(:page=>params[:page], :per_page=>25)
  end

  def tag
    @storages= @user.storages.for_index.tagged_with(params[:word], :on=>:storages).all.paginate(:page=>params[:page], :per_page=>25)
    render :action => :index
  end

  # TODO: restricted area!
  def show
    @storage.increment!(:show_count)
    @uploaded_file = UploadedFile.new
    @uploaded_files = @storage.uploaded_files.reversed_nested_set.active.all.paginate(:page=>params[:page], :per_page=>25)
  end

  # restricted area

  def new
    @storage = Storage.new
  end

  def create
    @storage= @user.storages.new(params[:storage])
    if @storage.save
      redirect_to edit_storage_url(@storage, :subdomain=>@user.subdomain), :notice => t('storages.created')
    else
      render :action=>:new
    end
  end

  def edit; end

  def update 
    if @storage.update_attributes(params[:storage])
      set_storage_state
      redirect_to edit_storage_url(@storage, :subdomain=>@user.subdomain), :notice => t('storages.updated')
    else
      render :action=>:edit
    end
  end

  def manage
    @storages= @user.storages.reversed_nested_set.for_manage.all.paginate(:page=>params[:page], :per_page=>25,
                                                                          :select=>[:id, :zip, :title, :state, :moderation_state, :parent_id, :lft, :rgt])
  end

  def restructure
    parent_id = params[:parent_id].to_i
    prev_id   = params[:prev_id].to_i
    next_id   = params[:next_id].to_i

    render :text=>"alert('do nothing');" and return if parent_id.zero? && prev_id.zero? && next_id.zero?

    # havn't prev and next
    # have prev
    # have next
    if prev_id.zero? && next_id.zero?
      @storage.move_to_child_of @user.storages.find(parent_id)
    elsif !prev_id.zero?
      @storage.move_to_left_of @user.storages.find(prev_id)
    elsif !next_id.zero?
      @storage.move_to_right_of @user.storages.find(next_id)
    end

    render(:nothing=>true)
  end


  def destroy
    params[:hard] ? @storage.destroy : @storage.to_deleted
    redirect_to manage_storages_url(:subdomain=>@user.subdomain, :page=>params[:page])
  end
  
  protected

  # preparators
  def prepare_tag_list
    params[:storage][:tag_list] = params[:storage][:tag_list].mb_chars.downcase.to_s  if params[:storage][:tag_list]
  end

  # getters
  def get_storage_state
    if current_user.top_manager_of?(:publications)
      @moderation_state = :to_blocked_moderation  if params[:to_blocked_moderation]
      @moderation_state = :to_unsafe_moderation   if params[:to_unsafe_moderation]
      @moderation_state = :to_safe_moderation     if params[:to_safe_moderation]
    end

    @state = :to_published  if params[:to_published]
    @state = :to_personal   if params[:to_personal]
    @state = :to_restricted if params[:to_restricted]
    @state = :to_archived   if params[:to_archived]
    @state = :clear         if params[:clear]
  end

  # setters
  def set_storage_state
    unless @moderation_state.blank?
      @publication.send(@moderation_state)  if @storage.respond_to?(@moderation_state)
    end
    unless @state.blank?
      @storage.send(@state) if @storage.respond_to?(@state)
    end
  end

  # finders
  def find_storage
    if action_name == 'rebuild'
      @storage= @user.storages.find(params[:id].to_i)
    elsif action_name == 'show'
      #zip= params[:id].split('---').first
      @storage= @user.storages.find_by_zip(params[:id])
    else
      @storage= @user.storages.find_by_zip(params[:id])
    end
    access_denied and return unless @storage
    @audited_object=          @storage # audition system
    @object_for_role_system=  @storage # role system
  end

  def find_storages
    @storages= @user.storages # TODO: add scope as :active
  end

  # fixers
  def fix_url_by_redirect
    return if @user.owner?(@storage)
    redirect_to storage_url(@storage, :subdomain=>@storage.user.subdomain)
  end

end

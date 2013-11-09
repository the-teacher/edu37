class PagesController < ApplicationController
  # login
  before_filter :login_required, :except=> [:index, :show, :tag]
  # finders
  before_filter :find_page, :only=>[:show, :edit, :update, :rebuild, :destroy]
  # role
  before_filter :role_require, :except=>[:index, :show, :tag]
  before_filter :owner_and_role_require, :only=>[:edit, :update, :rebuild, :destroy]
  # preparators
  before_filter :get_page_state, :only=> [:update]
  before_filter :prepare_tag_list, :only=>[:create, :update]
  # comments
  before_filter :find_comments, :only=>[:show]
  # fixers
  before_filter :fix_url_by_redirect, :only=>[:show]
  before_filter :protect_from_crossdomain_sniffers, :only=>[:manage]

  def index
    @pages= @user.pages.nested_set.for_index.all.paginate(:select=>[:id, :zip, :title, :state, :parent_id, :lft, :rgt, :comments_count, :show_count], :page=>params[:page], :per_page=>50)
  end

  def tag
    @pages= @user.pages.fresh.tagged_with(params[:word], :on=>:pages).all.paginate(:page=>params[:page], :per_page=>25)
    render :action => :index
  end

  def show
    @page.increment!(:show_count)
  end

  # restricted area

  def new
    @page = Page.new
  end

  def create
    @page = Page.new(params[:page]).init(:user=>@user, :creator=>current_user)
    if @page.save
      flash[:notice] = t('pages.created')
      redirect_to(edit_page_url(@page, :subdomain=>@user.subdomain))
    else
      render :action => :new
    end
  end

  def edit; end

  def update 
    if @page.update_attributes(params[:page])
      set_page_state
      redirect_to(edit_page_url(@page, :subdomain=>@user.subdomain), :notice => t('pages.updated'))
    else
      render :action => :edit
    end
  end

  def manage
    scope = @user.top_manager? ? :all_states : :for_manage
    @pages= @user.pages.nested_set.send(scope).all.paginate(:select=>[:id, :zip, :title, :state, :parent_id, :lft, :rgt], :page=>params[:page], :per_page=>50)
  end

  def rebuild
    parent_id = params[:parent_id].to_i
    prev_id   = params[:prev_id].to_i
    next_id   = params[:next_id].to_i

    render :text=>"alert('do nothing');" and return if parent_id.zero? && prev_id.zero? && next_id.zero?

    # havn't prev and next
    # have prev
    # have next
    if prev_id.zero? && next_id.zero?
      @page.move_to_child_of @user.pages.find(parent_id)
    elsif !prev_id.zero?
      @page.move_to_right_of @user.pages.find(prev_id)
    elsif !next_id.zero?
      @page.move_to_left_of @user.pages.find(next_id)
    end

    render(:nothing=>true)
  end

  def destroy
    params[:hard] ? @page.destroy : @page.to_deleted
    redirect_to(manage_pages_url(:subdomain=>@user.subdomain, :page=>params[:page]))
  end

  protected

  def prepare_tag_list
    params[:page][:tag_list] = params[:page][:tag_list].mb_chars.downcase.to_s if params[:page][:tag_list]
  end

  def get_page_state
    if current_user.top_manager_of?(:publications)
      @moderation_state = :to_blocked_moderation  if params[:to_blocked_moderation]
      @moderation_state = :to_unsafe_moderation   if params[:to_unsafe_moderation]
      @moderation_state = :to_safe_moderation     if params[:to_safe_moderation]
    end

    @state = :to_draft      if params[:to_draft]
    @state = :to_published  if params[:to_published]
    @state = :to_restricted if params[:to_restricted]
    @state = :to_archived   if params[:to_archived]
    @state = :clear         if params[:clear]
  end

  def set_page_state
    unless @moderation_state.blank?
      @page.send(@moderation_state)  if @page.respond_to?(@moderation_state)
    end
    unless @state.blank?
      @page.send(@state) if @page.respond_to?(@state)
    end
  end

  def find_page
    if action_name == 'rebuild'
      @page= @user.pages.find(params[:id].to_i)
    elsif action_name == 'show'
      zip= params[:id].split('---').first
      @page= Page.find_by_zip(zip)
    else
      @page= Page.find_by_zip(params[:id])
    end

    access_denied and return unless @page
    @audited_object=          @page # audition system
    @object_for_role_system=  @page # role system
  end

  def find_comments
    @comments = @page.comments.published
  end

  def fix_url_by_redirect
    return if @user.owner?(@page)
    redirect_to page_url(@page, :subdomain=>@page.user.subdomain)
  end

end

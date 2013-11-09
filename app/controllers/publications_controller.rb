class PublicationsController < ApplicationController
  # login
  before_filter :login_required, :except=>[:index, :show, :tag]
  # finders
  before_filter :find_publication, :only=>[:show, :edit, :update, :rebuild, :destroy]
  # role system
  before_filter :role_require, :except=>[:index, :show, :tag]
  before_filter :owner_and_role_require, :only=>[:edit, :update, :rebuild, :destroy]
  # preparators
  before_filter :get_publication_state, :only=> [:update]
  before_filter :prepare_tag_list, :only=>[:create, :update]
  # comments
  before_filter :find_comments, :only=>[:show]
  # fixers
  before_filter :fix_url_by_redirect, :only=>[:show]
  before_filter :protect_from_crossdomain_sniffers, :only=>[:manage]

  def index
    if @user.is_main?
      @publications= Publication.for_root_index.moderation_safe.reversed_nested_set.all.paginate(:page=>params[:page], :per_page=>25)
    else
      @publications= @user.publications.for_index.reversed_nested_set.all.paginate(:page=>params[:page], :per_page=>25)
    end
  end

  def tag
    @publications= @user.publications.fresh.tagged_with(params[:word], :on=>:publications).all.paginate(:page=>params[:page], :per_page=>25)
    render :action => :index
  end

  def show
    @publication.increment!(:show_count)
  end

  # restricted area

  def new
    @publication = Publication.new
  end

  def create
    @publication = Publication.new(params[:publication]).init(:user=>@user, :creator=>current_user)
    if @publication.save
      redirect_to edit_news_url(@publication, :subdomain=>@user.subdomain), :notice => t('publications.created')
    else
      render :action => :new
    end
  end

  def edit; end

  def update
    if @publication.update_attributes(params[:publication])
      set_publication_state
      redirect_to edit_news_url(@publication, :subdomain=>@user.subdomain), :notice => t('publications.updated')
    else
      render :action => :edit
    end
  end

  def manage
    @publications= @user.publications.reversed_nested_set.for_manage.all.paginate(:page=>params[:page], :per_page=>25,
                                                                                  :select=>[:id, :zip, :title, :state, :moderation_state, :parent_id, :lft, :rgt])
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
      @publication.move_to_child_of @user.publications.find(parent_id)
    elsif !prev_id.zero?
      @publication.move_to_left_of @user.publications.find(prev_id)
    elsif !next_id.zero?
      @publication.move_to_right_of @user.publications.find(next_id)
    end

    render(:nothing=>true)
  end

  def destroy
    params[:hard] ? @publication.destroy : @publication.to_deleted
    redirect_to manage_news_index_url(:subdomain=>@user.subdomain, :page=>params[:page])
  end

  protected
  
  # preparators
  def prepare_tag_list
    params[:publication][:tag_list] = params[:publication][:tag_list].mb_chars.downcase.to_s if params[:publication][:tag_list]
  end
  
  # getters
  def get_publication_state
    if current_user.top_manager_of?(:publications)
      @moderation_state = :to_blocked_moderation  if params[:to_blocked_moderation]
      @moderation_state = :to_unsafe_moderation   if params[:to_unsafe_moderation]
      @moderation_state = :to_safe_moderation     if params[:to_safe_moderation]
    end

    @state = :to_published  if params[:to_published]
    @state = :to_draft      if params[:to_draft]
    @state = :to_restricted if params[:to_restricted]
    @state = :to_archived   if params[:to_archived]
    @state = :clear         if params[:clear]
  end

  # setters
  def set_publication_state
    unless @moderation_state.blank?
      @publication.send(@moderation_state)  if @publication.respond_to?(@moderation_state)
    end
    unless @state.blank?
      @publication.send(@state) if @publication.respond_to?(@state)
    end
  end

  # finders
  # TODO: shows to user only undeleted pubs, and all to top_manager
  def find_publication
    if action_name == 'rebuild'
      @publication= @user.publications.find(params[:id].to_i)
    elsif action_name == 'show'
      zip= params[:id].split('---').first
      @publication= Publication.find_by_zip(zip)
    else
      @publication= Publication.find_by_zip(params[:id])
    end

    access_denied and return unless @publication
    @audited_object=          @publication # audition system
    @object_for_role_system=  @publication # role system
  end

  def find_comments
    @comments = @publication.comments.published
  end

  # fixers
  def fix_url_by_redirect
    return if @user.owner?(@publication)
    redirect_to news_url(@publication, :subdomain=>@publication.user.subdomain)
  end

end

class ProfilesController < ApplicationController
  # login
  before_filter :login_required, :except=> [:index]
  # finders
  before_filter :find_profile, :only=>[:show, :edit, :update]
  # role system
  before_filter :owner_and_role_require, :only=>[:edit, :update]
  # preparators
  before_filter :get_profile_state, :only=> [:update]
  before_filter :prepare_tag_list, :only=>[:update]
  # comments
  before_filter :find_comments, :only=>[:index]
  # fixers
  before_filter :fix_url_by_redirect, :only=>[:show, :edit]
  before_filter :protect_from_crossdomain_sniffers, :only=>[:edit]

  def index
    @profile= @user.profile
  end

  def edit; end

  def update
    if @profile.update_attributes(params[:profile])
      redirect_to edit_profile_url(@profile, :subdomain=>@profile.user.subdomain), :notice => t('profiles.updated')
    else
      render :action => "edit"
    end
  end

  protected

  def find_profile
    @profile= @user.profile
    access_denied and return unless @profile
    @audited_object=          @profile # audition system
    @object_for_role_system=  @profile # role system
  end

  def prepare_tag_list
    params[:profile][:tag_list] = params[:profile][:tag_list].mb_chars.downcase.to_s if params[:profile][:tag_list]
  end

  def get_profile_state
    if current_user.top_manager_of?(:profiles)
      @moderation_state = :to_blocked_moderation  if params[:to_blocked_moderation]
      @moderation_state = :to_unsafe_moderation   if params[:to_unsafe_moderation]
      @moderation_state = :to_safe_moderation     if params[:to_safe_moderation]
    end

    @state = :to_published  if params[:to_published]
    @state = :to_restricted if params[:to_restricted]
    @state = :clear         if params[:clear]
  end

  def find_comments
    @comments = @user.comments
  end

  # fixers
  def fix_url_by_redirect
    return if @user.owner?(@profile)
    redirect_to profiles_url(@profile, :subdomain=>@profile.user.subdomain)
  end

end

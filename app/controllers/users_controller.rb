class UsersController < ApplicationController
  before_filter :login_required, :only=> [:cabinet, :update, :avatar_upload, :site_header_upload]
  before_filter :role_require, :only=> [:cabinet, :update, :avatar_upload, :site_header_upload]
  before_filter :protect_from_crossdomain_sniffers, :only=>[:cabinet, :update, :avatar_upload, :site_header_upload]
  before_filter :new_comment, :find_comments, :only=>[:show]

  def index
    role = params[:role] if params[:role]
    unless role.blank?
      if ['admin', 'user'].include? role
        @users= Role.where(:name=>role).first.users.fresh.paginate(:page => params[:page], :per_page=>30)
        render :action=>:index and return
      end#if
    end#unless
    @users = User.fresh.all.paginate(:page=>params[:page], :per_page=>30)
  end#index

  def new
    @prereg = Prereg.new
  end

  def show; end

  def lang
    locale= Project::LOCALE_COOKIES_NAME
    lang = Project::LOCALES.include?(params[:lang]) ? params[:lang] : :en
    cookies[locale] = {
      :value   => lang,
      :expires => 1.year.from_now.utc,
      :path => '/',
      :domain => Project::COOKIES_SCOPE
    }
    redirect_back_or(root_path)
  end

  # restricted area

  def avatar_upload
    @user.avatar    = params[:user][:avatar]
    avatar_uploaded = @user.save 
    flash[:notice]  = t('users.avatar.uploaded') if avatar_uploaded
    flash[:error]   = t('users.avatar.not_uploaded') unless avatar_uploaded
    redirect_to edit_profile_url(@user, :subdomain=>@user.subdomain)
  end

  def site_header_upload
    @user.site_header    = params[:user][:site_header]
    site_header_uploaded = @user.save 
    flash[:notice]  = t('users.site_header.uploaded') if site_header_uploaded
    flash[:error]   = t('users.site_header.not_uploaded') unless site_header_uploaded
    redirect_to edit_profile_url(@user, :subdomain=>@user.subdomain)
  end

  def cabinet; end

  def update
    if @user.update_attributes(params[:user])
      redirect_to edit_profile_url(@user, :subdomain=>@user.subdomain), :notice => t('users.updated')
    else
      flash[:error] = t('users.not_updated')
      redirect_to edit_profile_url(@user, :subdomain=>@user.subdomain)
    end
  end

  protected

  def find_user
    @user= User.find_by_zip(params[:id])
    access_denied and return unless @user
  end

  def find_comments
    @comments = @user.comments.published
  end

# TODO: delete 29.05.2011
=begin
  def create
    logout_keeping_session!
    @user = User.new(params[:user])
    success = @user && @user.save
    if success && @user.errors.empty?
      # Protects against session fixation attacks, causes request forgery
      # protection if visitor resubmits an earlier form using back
      # button. Uncomment if you understand the tradeoffs.
      # reset session
      self.current_user = @user # !! now logged in
      redirect_to(cabinet_users_url(:subdomain=>current_user.subdomain), :notice => t('users.create'))
    else
      flash.now[:error]  = t('users.error_on_create')
      render :action => 'new'
    end
  end
=end

end

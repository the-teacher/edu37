class ApplicationController < ActionController::Base
  include AuthenticatedSystem

  # For controller/action
  # protect_from_forgery :except => [:up, :down]
  protect_from_forgery
  # System
  before_filter :set_locale
  before_filter :init_user_and_subdomain
  # Audit
  after_filter  :audition, :only=>[:new, :create, :edit, :update, :show, :index, :manage, :restructure, :tag, :preview, :up, :down, :invite]
  before_filter :audition, :only=>[:destroy]
  # Comments
  before_filter :new_comment, :only=>[:show]

  def init_user_and_subdomain
    raise RuntimeError.new( t('system.have_no_users') ) if User.count.zero?
    @subdomain= nil
    @root= User.first
    @user= current_user ? current_user : @root
    @user= @root unless current_subdomain
    
    if current_subdomain
      match= current_subdomain.match(/^www.(.+)/)
      @subdomain= match.nil? ? current_subdomain : match[1]
      user= User.find_by_login(@subdomain)
      unless user
        # TODO: custom flash functional 
        # flash[:system_warnings].push(t('system.domain_does_not_exist'))
        @subdomain= nil
      end
      @user= user ? user : @user
    end
  end

  def redirect_back_or(path)
    redirect_to :back
    rescue ActionController::RedirectBackError
    redirect_to path
  end

  def set_locale
    locale= Project::LOCALE_COOKIES_NAME
    Project::LOCALES.include?(cookies[locale]) ? (I18n.locale = cookies[locale]) : (I18n.locale = :en) if cookies[locale]
  end

  def protect_from_crossdomain_sniffers
    return true if current_user.subdomain.blank? && current_subdomain.blank?  # root aka God
    return true if current_user.top_manager?                                  # admin or moderator
    return true if current_user.subdomain == current_subdomain                # owner
    redirect_to cabinet_users_url(:subdomain=>current_user.subdomain)
  end

  def access_denied
    store_location
    flash[:notice] = t('base.access_denied')
    redirect_to root_url(:subdomain=>@user.subdomain)
  end

  protected

  # Audit
  def audition
    @user.audits.new.init(:request=>request, :object=>@audited_object, :controller=>controller_name, :action=>action_name).save
  end

  # Role system
  def role_require
    access_denied unless current_user.has_role?(controller_name, action_name)
  end

  def owner_and_role_require
    access_denied unless current_user.owner?(@object_for_role_system) && current_user.has_role?(controller_name, action_name)
  end

  # Comments
  def new_comment
    @comment = Comment.new
  end

end

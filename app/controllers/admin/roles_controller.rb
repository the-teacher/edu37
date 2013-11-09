class Admin::RolesController < ApplicationController
  # login
  before_filter :login_required
  # role
  before_filter :role_require
  # finders
  before_filter :find_role, :only=>[:show, :edit, :update, :destroy, :new_role_section, :new_role_rule]

  def index
    @roles = Role.paginate(:all,
                           :order=>"created_at ASC", #ASC, DESC
                           :page => params[:page],
                           :per_page=>10
                           )
  end

  def show; end
  def edit; end

  def new
    @role = Role.new
  end

  def create
    @role = Role.new(params[:role])

    if @role.save
      flash[:notice] = t('roles.created')
      redirect_to(edit_admin_role_path(@role))
    else
      render :action => "new"
    end
  end

  def update
    params[:role] = Hash.new unless params[:role]
    new_role= params[:role][:settings] ? params[:role][:settings] : Hash.new
    role= @role.settings.is_a?(String) ? YAML::load(@role.settings) : Hash.new
    role= role.recursive_set_values_on_default!
    role.recursive_merge_with_default!(new_role)
    params[:role][:settings]= role.to_yaml
    
    if @role.update_attributes(params[:role])
      flash[:notice] = t('roles.updated')
      redirect_back_or(admin_role_path(@role))
    else
      render :action => "edit"
    end
  end

  def destroy
    @role.destroy and redirect_to(admin_roles_url)
  end
  
  def new_role_section
    # validate 1
    if params[:section_name].blank?
      flash[:warning] = t('roles.section_name_is_blank')
      redirect_back_or(admin_role_path(@role)) and return
    end

    # validate 2
    section_name= params[:section_name]
    unless section_name.match(Format::LATIN_AND_SAFETY_SYMBOLS)
      flash[:warning] = t('roles.section_name_is_wrong')
      redirect_back_or(admin_role_path(@role)) and return
    end

    section_name.downcase!
    role= @role.settings.is_a?(String) ? YAML::load(@role.settings) : Hash.new
    # role= Hash.new unless role.is_a?(Hash)

    # validate 3
    if role[section_name.to_sym]
      flash[:warning] = t('roles.section_exists')
      redirect_back_or(admin_role_path(@role)) and return
    end

    role[section_name.to_sym]= Hash.new
    
    if @role.update_attributes({:settings=>role.to_yaml})
      flash[:notice] = t('roles.section_created')
      redirect_back_or(admin_role_path(@role))
    else
      render :action => "edit"
    end
  end#new_role_section
  
  def new_role_rule
    params[:section_rule].downcase!
    
    # validate 1
    unless params[:section_rule].match(Format::LATIN_AND_SAFETY_SYMBOLS)
      flash[:warning] = t('roles.section_rule_wrong_name')
      redirect_back_or(admin_role_path(@role))
    end

    role= @role.settings.is_a?(String) ? YAML::load(@role.settings) : Hash.new        
    role[params[:section_name].to_sym][params[:section_rule].to_sym]= true 

    if @role.update_attributes({:settings=>role.to_yaml})
      flash[:notice] = t('roles.section_rule_created')
      redirect_back_or(admin_role_path(@role))
    else
      render :action => "edit"
    end
  end#new_role_rule

  protected

  def find_role
    @role = Role.find_by_zip(params[:id])
  end
  
end

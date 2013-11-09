class Admin::RoleSectionController < ApplicationController
  before_filter :login_required
  before_filter :find_role, :only=>[:destroy, :delete_rule]
  
  def destroy
    section_name= params[:id]
    role= @role.settings.is_a?(String) ? YAML::load(@role.settings) : Hash.new
    role.delete(section_name.to_sym)
    
    if @role.update_attributes({:settings=>role.to_yaml})
      flash[:notice] = t('roles.section_destroyed')
      redirect_back_or(admin_role_path(@role))
    else
      render :action => "edit"
    end   
  end#destroy
  
  def delete_rule
    section_name= params[:id]
    rule_name= params[:name]
    role= @role.settings.is_a?(String) ? YAML::load(@role.settings) : Hash.new
    role[section_name.to_sym].delete(rule_name.to_sym)
    
    if @role.update_attributes({:settings=>role.to_yaml})
      flash[:notice] = t('roles.section_rule_destroyed')
      redirect_back_or(admin_role_path(@role))
    else
      render :action => "edit"
    end
  end#delete_rule

  protected

  def find_role
    @role = Role.find_by_zip(params[:role_id])
  end
end

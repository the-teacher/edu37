class UploadedFilesController < ApplicationController
  # login
  before_filter :login_required
  # finders
  before_filter :find_storage
  before_filter :find_uploaded_file, :only=>[:destroy]
  # role system
  before_filter :role_require
  before_filter :owner_and_role_require, :only=>[:destroy]  

  # restricted area

  def create
    @uploaded_file = @storage.uploaded_files.new(params[:uploaded_file])
    @uploaded_file.user= @user
    
    if @uploaded_file.save
      flash[:notice] = t('uploaded_files.created')
      redirect_to storage_url(@storage, :subdomain=>@user.subdomain, :page=>params[:page])
    else
      @storage.increment!(:show_count)
      @uploaded_files = @storage.uploaded_files.reversed_nested_set.all.paginate(:page=>params[:page], :per_page=>25)
      render :action => 'storages/show'
    end
  end

  def destroy
    @storage= @uploaded_file.storage
    params[:hard] ? @uploaded_file.destroy : @uploaded_file.to_deleted
    flash[:notice] = t('uploaded_files.deleted')
    redirect_to storage_url(@storage, :subdomain=>@user.subdomain) and return
  end

  protected

  def find_storage
    @storage = @user.storages.active.find_by_zip(params[:storage])
    unless @storage
      flash[:error]= t('uploaded_files.storage_not_found')
      redirect_to storage_url(@storage, :subdomain=>@user.subdomain) and return
    end    
  end

  def find_uploaded_file
    @uploaded_file= @user.uploaded_files.find_by_zip(params[:id])
    access_denied and return unless @uploaded_file
    @audited_object = @uploaded_file
  end

end

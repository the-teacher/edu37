class PreregsController < ApplicationController
  before_filter :find_prereg, :only=>[:invite, :destroy]

  def index
    @preregs= Prereg.pending
  end

  def invite
    render :text=>@prereg.name and return
    User.new(:name=>@prereg, :email=>@prereg.email).save
  end

  def create
    @name = params[:prereg][:name].strip
    @email = params[:prereg][:email].strip

    post_services = ['yandex.ru', 'ya.ru', 'mail.ru', 'rambler.ru', 'gmail.com']    
    email_regexp = post_services.join('|')
    
    @prereg= Prereg.new(:name=>@name, :email=>@email)
    
    # TODO: Refactor this
    if @email.blank?
      @prereg.errors.add(:email, t('preregs.blank_email') )
      render :action=>'users/new' and return
    elsif !@email.match(Format::EMAIL)
      flash[:notice] = t('preregs.wrong_email')
      render :action=>'users/new' and return
    elsif !@email.match /(#{email_regexp})$/
      flash[:notice] = t('preregs.email_notice') + post_services.join(', ')
      render :action=>'users/new' and return
    end
  
    @prereg= Prereg.new(:name=>@name, :email=>@email)
    unless @prereg.save
      render :action=>'users/new' and return
    end
    @audited_object = @prereg
    render :action=>:new
  end#create

  def destroy
    render :text=>@prereg.name and return
  end

  def find_prereg
    @prereg= Prereg.find params[:id]
    access_denied and return unless @prereg
    @audited_object = @forum
  end
end

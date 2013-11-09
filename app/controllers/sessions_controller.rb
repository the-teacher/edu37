class SessionsController < ApplicationController
  include AuthenticatedSystem

  def new; end

  def create
    logout_keeping_session!
    user = User.where(:crypted_password=>params[:password].upcase.strip).first #User.authenticate(params[:login], params[:password])
    if user
      # Protects against session fixation attacks, causes request forgery
      # protection if user resubmits an earlier form using back
      # button. Uncomment if you understand the tradeoffs.
      # reset_session
      self.current_user = user
      new_cookie_flag = !(params[:unsefty_workplace] == "1")
      handle_remember_cookie! new_cookie_flag
      redirect_to(cabinet_users_url(:subdomain=>current_user.subdomain), :notice => t('sessions.notice.logined'))
    else
      # note_failed_signin
      @login       = params[:login]
      @remember_me = params[:remember_me]
      flash[:error] = t('sessions.error.wrong_login_data')
      redirect_back_or(root_path)
    end
  end

  def destroy
    logout_killing_session!
    redirect_to(root_url, :notice => t('sessions.notice.logged_out'))
  end

protected
  # Track failed login attempts
  def note_failed_signin
    flash.now[:error] = "Couldn't log you in as '#{params[:login]}'"
    logger.warn "Failed login for '#{params[:login]}' from #{request.remote_ip} at #{Time.now.utc}"
  end
end

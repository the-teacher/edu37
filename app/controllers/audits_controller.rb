class AuditsController < ApplicationController
  # login
  before_filter :login_required
  # role
  before_filter :role_require

  def index
    ya_bot_1 = 'Mozilla/5.0 (compatible; YandexBot/3.0; +http://yandex.com/bots)'
    ya_bot_2 = 'Mozilla/5.0 (compatible; YandexWebmaster/2.0; +http://yandex.com/bots)'

    @yandex_01_last_visit = Audit.where(:user_agent=>ya_bot_1).select('created_at').last.try(:created_at)
    @yandex_02_last_visit = Audit.where(:user_agent=>ya_bot_2).select('created_at').last.try(:created_at)

    goo_bot_1 = 'Mozilla/5.0 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)'
    goo_bot_2 = 'Mozilla/5.0 (en-us) AppleWebKit/525.13 (KHTML, like Gecko; Google Web Preview) Version/3.1 Safari/525.13'

    @google_01_last_visit = Audit.where(:user_agent=>goo_bot_1).select('created_at').last.try(:created_at)
    @google_02_last_visit = Audit.where(:user_agent=>goo_bot_2).select('created_at').last.try(:created_at)

    @user_agents = Audit.all(:select => 'DISTINCT user_agent', :order=>'user_agent')

    @publications_ya = Audit.where("user_agent = ? and object_type = ? and action = ?", ya_bot_1, 'Publication', 'show').select('DISTINCT object_zip').order('created_at')
    @publications_goo = Audit.where("user_agent = ? and object_type = ? and action = ?", goo_bot_1, 'Publication', 'show').select('DISTINCT object_zip').order('created_at')
  end

  protected
  
  #nothing
end

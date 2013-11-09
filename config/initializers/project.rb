module Project
  # base consts
  ROOT_DOMAIN = "edu37.ru"
  ROOT_LOGIN = "root"
  ADDRESS = "http://edu37.ru"
  ADMIN_EMAIL = "zykin-ilya@ya.ru"
  COOKIES_SCOPE = ".edu37.ru" # auth for all subdomains

  # uploads
  AVATARA_URL = "/uploads/:login/:attachment/:style/:filename"
  AVATARA_DEFAULT = "/uploads/default/:attachment/:style/missing.jpg"

  SITE_HEADER_URL = "/uploads/:login/:attachment/:style/:filename"
  SITE_HEADER_DEFAULT = "/uploads/default/:attachment/:style/missing.jpg"

  FILE_URL = "/uploads/:holder_login/:style/:filename"
  FILE_DEFAULT = "/uploads/default/:style/missing.jpg"

  # Cookies Easter Egg's
  SESSION_STORE_KEY = 'Joseph_Stalin'
  AUTH_TOKEN = 'Lavrentiy_Beria'

  VIEW_TOKEN = 'Georgy_Malenkov'
  VIEW_TOKEN_EXPIRES = 2.weeks.from_now.utc

  VOTING_DELAY = 1 # in minutes

  LOCALE_COOKIES_NAME = 'Lazar_Kaganovich'
  LOCALES = ['ru', 'en', 'ua', 'fr']

  # Vyacheslav_Molotov

  CODE_LANGS = [:bash, :shell,
                :cpp, :c,
                :"c#", :"c-sharp", :csharp,
                :css,
                :delphi, :pascal,
                :diff, :patch,
                :groovy,
                :java,
                :js, :jscript, :javascript,
                :perl, :pl,
                :php, :php4, :php5,
                :text, :txt, :plain,
                :python, :py,
                :ruby, :rb,
                :scala,
                :sql,
                :vb, :vbnet,
                :xml, :xhtml, :xslt, :html]

  def self.get_view_token(cookies)
    return false unless cookies.is_a?(ActionDispatch::Cookies::CookieJar)
    domain=             Project::COOKIES_SCOPE
    view_token=         Project::VIEW_TOKEN
    view_token_expires= Project::VIEW_TOKEN_EXPIRES

    token= Digest::SHA1.hexdigest("#{rand.to_s}_#{Time.now.to_s}")
    unless cookies[view_token]
      cookies[view_token] = {
        :value   => token,
        :expires => view_token_expires,
        :path => '/',
        :domain => domain 
      }
    end
    return cookies[view_token]
  end#get_view_token
end

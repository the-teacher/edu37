class Audit < ActiveRecord::Base
    # http://pullmonkey.com/2008/4/21/ruby-on-rails-multiple-database-connections/
    # establish_connection "audit_#{Rails.env}"

    belongs_to :user
    belongs_to :object, :polymorphic =>true
    
    def init options= {}
      self.controller=  options[:controller]
      self.action=      options[:action]
      self.object=      options[:object]

      self.object_zip=  options[:object][:zip] if options[:object]
      return self unless options[:request].is_a?(ActionDispatch::Request)

      self.ip=          options[:request].ip
      self.user_agent=  options[:request].user_agent
      self.remote_ip=   options[:request].remote_ip
      self.remote_addr= options[:request].remote_addr
      self.remote_host= options[:request].remote_host
      self.request_uri= CGI::unescape(options[:request].request_uri)
      self.referer=     CGI::unescape(options[:request].referer)
      return self
    end
end

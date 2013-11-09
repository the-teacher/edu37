class Admin::AuditsController < Puffer::Base
  # login
  # role
  before_filter :login_required
  before_filter :role_require

  setup do
    group :audits
  end

  index do
    field :id
    field :user_id
    field :object_type
    field :object_id
    field :object_zip
    field :controller
    field :action
    field :ip
    field :remote_ip
    field :request_uri, :render => lambda {|record| CGI::unescape(record.request_uri)}
    field :referer
    field :user_agent
    field :remote_addr
    field :remote_host
    field :created_at
    field :updated_at
  end

  form do
    field :id
    field :user_id
    field :object_type
    field :object_id
    field :object_zip
    field :controller
    field :action
    field :ip
    field :remote_ip
    field :request_uri
    field :referer
    field :user_agent
    field :remote_addr
    field :remote_host
    field :created_at
    field :updated_at
  end

end

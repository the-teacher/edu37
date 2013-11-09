class Admin::VotesController < Puffer::Base
  # login
  # role
  before_filter :login_required
  before_filter :role_require

  setup do
    group :votes
  end

  index do
    field :id
    field :user_id
    field :object_id
    field :object_type
    field :value
    field :ip
    field :remote_ip
    field :view_token
    field :created_at
    field :updated_at
  end

  form do
    field :id
    field :user_id
    field :object_id
    field :object_type
    field :value
    field :ip
    field :remote_ip
    field :view_token
    field :created_at
    field :updated_at
  end

end

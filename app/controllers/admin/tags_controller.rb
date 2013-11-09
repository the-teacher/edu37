class Admin::TagsController < Puffer::Base
  # login
  # role
  before_filter :login_required
  before_filter :role_require

  setup do
    group :tags
  end

  index do
    field :id
    field :name
  end

  form do
    field :id
    field :name
  end

end

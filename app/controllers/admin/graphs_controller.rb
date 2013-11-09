class Admin::GraphsController < Puffer::Base
  # login
  # role
  before_filter :login_required
  before_filter :role_require

  setup do
    group :graphs
  end

  index do
    field :id
    field :zip
    field :context
    field :sender_id
    field :sender_role
    field :recipient_id
    field :recipient_role
    field :state
    field :created_at
    field :updated_at
  end

  form do
    field :id
    field :zip
    field :context
    field :sender_id
    field :sender_role
    field :recipient_id
    field :recipient_role
    field :state
    field :created_at
    field :updated_at
  end

end

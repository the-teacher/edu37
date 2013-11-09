class Admin::TaggingsController < Puffer::Base
  # login
  # role
  before_filter :login_required
  before_filter :role_require

  setup do
    group :taggings
  end

  index do
    field :id
    field :tag_id
    field :taggable_id
    field :taggable_type
    field :tagger_id
    field :tagger_type
    field :context
    field :created_at
  end

  form do
    field :id
    field :tag_id
    field :taggable_id
    field :taggable_type
    field :tagger_id
    field :tagger_type
    field :context
    field :created_at
  end

end

class Message < ActiveRecord::Base

  state_machine :state, :initial => :unsafe do
    event :to_spam do
      transition all => :spam
    end
    event :to_moderated do
      transition all => :moderated
    end
    event :to_deleted do
      transition all => :deleted
    end
    event :clear do
      transition all => :unread
    end
  end

  state_machine :read_state, :initial => :unread do
    event :to_readed do
      transition all => :readed
    end
    event :to_unread do
      transition all => :unread
    end
  end

  def init(opts= {})
    if opts[:user]
      self.user_id=    opts[:user].id
      self.user_zip=   opts[:user].zip
      self.user_login= opts[:user].login
    end

    if opts[:creator]
      self.creator_id=    opts[:creator].id
      self.creator_zip=   opts[:creator].zip
      self.creator_login= opts[:creator].login
    end
    return self
  end

end

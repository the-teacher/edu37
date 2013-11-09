class Role < ActiveRecord::Base

  has_many :users

  def to_param
    self.zip
  end

end

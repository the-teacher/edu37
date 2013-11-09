class Vote < ActiveRecord::Base
  belongs_to :object, :polymorphic =>true
  scope :positive, where('value  > 0')
  scope :negative, where('value  < 0')
  
  def init(options= {})
    opts= {
      :value=>1,
      :user=> nil,
      :request=>nil
    }.merge!(options)
    # do nothing if we have no objects: REQUEST and COOKIES
    return false unless opts[:request].is_a?(ActionDispatch::Request)
    return false unless opts[:cookies].is_a?(ActionDispatch::Cookies::CookieJar)
    # set ip
    self.ip = opts[:request].ip
    self.remote_ip = opts[:request].remote_ip
    # set user_id    
    self.user_id = opts[:user].id if opts[:user].is_a?(User)
    # set view token
    # config/initializers/project.rb
    self.view_token=  Project::get_view_token(opts[:cookies])
    # vote value (float)
    self.value = opts[:value]
    return self
  end

  after_save :recalculate_votes_values
  
  def recalculate_votes_values
    obj= self.object    
    pos= 0; neg= 0
    obj.votes.positive.each{|v| pos+= v.value}
    obj.votes.negative.each{|v| neg+= v.value}
    obj.positive_value= pos
    obj.negative_value= neg
    obj.save
  end
end

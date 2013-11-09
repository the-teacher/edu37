class Graph < ActiveRecord::Base
  scope :pending,   where(:state => :pending)  
  scope :accepted,  where(:state => :accepted)
  scope :rejected,  where(:state => :rejected)
  scope :deleted,   where(:state => :deleted)

  #state pending, accepted, rejected, deleted
  state_machine :state, :initial => :pending do
    event :accept do
      transition :pending => :accepted
    end
    event :reject do
      transition :pending => :rejected
    end
    event :delete do
      transition all => :deleted
    end
    event :initial do
      transition all => :pending
    end
  end

end

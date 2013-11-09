class Prereg < ActiveRecord::Base
  validates :name, :presence => {:message => 'Вы забыли указать свое имя'},
                   :length   => {:within => 15..60, :message => 'длинна имени должна быть от 15 до 60 символов'}

  validates :email, :presence   => {:message => I18n.translate('prereg.failure')},
                    :uniqueness => {:message => 'очень жаль, но, кажется, такой адрес не удасться зарегистрировать'},
                    :length     => {:within => 8..40, :message => 'длинна адреса электронной почты не соответствует требуемому формату'},
                    :format     => {:with => Format::EMAIL, :message => I18n.translate('prereg.failure') }

  scope :pending, where(:state => :pending)

  state_machine :state, :initial => :pending do
    event :activate do
      transition [:pending] => :activated
    end
    event :clear do
      transition all => :pending
    end
  end

  def random_hash_key
    hash_key= ''
    pass_char= []
    nums= '123456789'
    lowcase= 'qwertyuipasdfghjklzxcvbnm'
    upcase= 'QWERTYUIPASDFGHJKLZXCVBNM'
    (nums+upcase).each_char{|c| pass_char.push c}
    10.times{hash_key<< pass_char.rand}
    hash_key
  end

  before_create :create_hash_key
  def create_hash_key
    self.hash_key= self.random_hash_key
  end
end

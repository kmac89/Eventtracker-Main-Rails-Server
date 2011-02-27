class User < ActiveRecord::Base
  acts_as_authentic do |c|
    c.validate_email_field = false
  end

  has_many :events, :dependent => :destroy

  validates :uuid, :presence => true
  validates :phone_number, :presence => true
  validates :password_hash, :presence => true

#  def to_param
#    phone_number
#  end

end

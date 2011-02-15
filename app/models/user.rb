class User < ActiveRecord::Base
  has_many :events, :dependent => :destroy

  validates :uuid, :presence => true
  validates :phone_number, :presence => true
  validates :password_hash, :presence => true

#  def to_param
#    phone_number
#  end

end

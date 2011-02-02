class User < ActiveRecord::Base
  has_many :events

  validates :uuid, :presence => true
  validates :phone_number, :presence => true

  def to_param
    uuid
  end

end

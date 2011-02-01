class User < ActiveRecord::Base
  has_many :events

  def to_param
    uuid
  end

end

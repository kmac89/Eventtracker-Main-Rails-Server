class Event < ActiveRecord::Base
  belongs_to :user

  validates :uuid, :presence => true
  validates :user_uuid, :presence => true

  def to_param
    uuid
  end
end

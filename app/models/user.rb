class User < ActiveRecord::Base
  acts_as_authentic do |c|
    c.validate_email_field = false
    c.require_password_confirmation = false
    c.login_field = :phone_number
  end

  has_many :events, :dependent => :destroy

  validates :uuid, :presence => true
  validates :phone_number, :presence => true

end

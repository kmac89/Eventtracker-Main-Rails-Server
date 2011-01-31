#require 'lib/uuid_helper'

class Event < ActiveRecord::Base
# include UUIDHelper

  belongs_to :user

  def to_param
    uuid
  end
end

require 'uuidtools'

class Event < ActiveRecord::Base
  belongs_to :user
  before_create :init_defaults
  DATE_TIME_FORMAT = '%I:%M%p %b %d, %Y'

  validates :user_id, :presence => true

  def Event.time_long_to_s(long_time)
    epoch_time = Time.at(long_time / 1000)
    epoch_time.strftime(DATE_TIME_FORMAT)
  end

  def Event.time_s_to_long(string_time)
    dt = DateTime.strptime(string_time, DATE_TIME_FORMAT)
    dt.advance(:hours => 8).to_time.to_i * 1000
  end

  def check_start_time_before_end(start_time, end_time)
    errors.add_to_base('Start time must be before end time.') if start_time > end_time
  end

  def init_defaults
    self.uuid = UUIDTools::UUID.timestamp_create().to_s unless !self.uuid.nil?
    self.content = '{}' unless !self.content.nil?
    self.deleted = false unless !self.deleted.nil?
  end
end

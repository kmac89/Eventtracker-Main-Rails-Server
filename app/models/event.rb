class Event < ActiveRecord::Base
  belongs_to :user
  DATE_TIME_FORMAT = '%I:%M%p %b %d, %Y'

  validates :uuid, :presence => true
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

#  def to_param
#    uuid
#  end
end

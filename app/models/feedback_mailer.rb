class FeedbackMailer < ActionMailer::Base
  default :from => "timenova.feedback@gmail.com"
  def feedback(feedback)
    @feedback = feedback
    mail(:to => 'time-nova@googlegroups.com', :subject => "[Feedback for Time Nova]")
  end
end

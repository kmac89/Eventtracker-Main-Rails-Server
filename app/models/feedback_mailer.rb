class FeedbackMailer < ActionMailer::Base
  default :from => "eventtracker.feedback@gmail.com"
  def feedback(feedback)
    @feedback = feedback
    mail(:to => 'kmac89@berkeley.edu', :subject => "[Feedback for Eventtracker]")
  end
end

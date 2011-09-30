class FeedbackMailer < ActionMailer::Base
  def feedback(feedback)
    @recipients  = 'kmac89@berkeley.edu'
    @from        = 'eventtracker.feedback@gmail.com'
    @subject     = "[Feedback for Eventtracker] #{feedback.subject}"
    @sent_on     = Time.now
    @body[:feedback] = feedback
  end
end

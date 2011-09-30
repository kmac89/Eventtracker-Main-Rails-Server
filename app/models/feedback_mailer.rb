class FeedbackMailer < ActionMailer::Base
  default :from => "eventtracker.feedback@gmail.com"
  def feedback(feedback)
    logger.debug feedback.comment
    @recipients  = 'kmac89@berkeley.edu'
    @from        = 'eventtracker.feedback@gmail.com'
    @subject     = "[Feedback for Eventtracker] #{feedback.subject}"
    @sent_on     = Time.now
    @body[:feedback] = feedback
  end
   def feedback2(feedback)
     mail(:to => 'kmac89@berkeley.edu', :subject => "Welcome to My Awesome Site")
   end
end

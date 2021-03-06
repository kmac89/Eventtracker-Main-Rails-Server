class UserSession < Authlogic::Session::Base

  generalize_credentials_error_messages "Wrong phone number/password combination" 

  def to_key
     new_record? ? nil : [ self.send(self.class.primary_key) ]
  end
  
  def persisted?
    false
  end
end

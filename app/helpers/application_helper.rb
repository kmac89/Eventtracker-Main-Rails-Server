module ApplicationHelper
  def check_errors
    begin
      return yeild
    rescue Exception => e
      return "<html><body>So, sorry, you suck.</body></html>"
    end
  end
end

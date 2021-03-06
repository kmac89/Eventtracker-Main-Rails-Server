class ApplicationController < ActionController::Base
  protect_from_forgery

  helper_method :current_user
  before_filter :set_csp

  private

  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end

  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.record
  end

  # Sets the content security policy by modifying the http headers
  def set_csp
    logger.debug "HELLO I AM A CSP"
    response.headers['X-Content-Security-Policy'] = "default-src 'self'; report-uri http://127.0.0.1:3000/csp_report"
  end
end

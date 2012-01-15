class HomeController < ApplicationController
  def csp_report
    logger.debug "CSP-REPORT"
    render :nothing => true
  end
end

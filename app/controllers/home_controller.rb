class HomeController < ApplicationController
  skip_before_filter :verify_authenticity_token
  def index
    if current_user
      redirect_to "/#{current_user.phone_number}"
    else
      @user_session = UserSession.new
    end
  end
end

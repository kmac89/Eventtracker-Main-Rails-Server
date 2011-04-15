class HomeController < ApplicationController
  skip_before_filter :verify_authenticity_token
  def index
    if current_user
      redirect_to "/#{current_user.phone_number}"
    else
      @user_session = UserSession.new
    end
  end

  def update_ip
    check_errors do
      ip = params[:ip]
      user_id = params[:user_id]

      # is_valid? should actually be a validator on the User model
      throw "Invalid IP address" unless is_valid?(id)

      user = User.first(user_id)
      user.ip = ip

      # However active_record says that things were saved correctly should be checked
      user.save

      # We don't actually want to render a view here, so don't do that...
      "Thanks for the update"
    end
  end

  def test
    puts "Parameters: #{params.inspect}"
    puts "Content: #{request.raw_post}"
  end

  def close
  end
end

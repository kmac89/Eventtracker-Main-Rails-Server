class UserSessionsController < ApplicationController

  # GET /user_sessions/new
  # GET /user_sessions/new.xml
  def new
    if current_user
      redirect_to "/#{current_user.phone_number}"
      return
    else
      @user_session = UserSession.new
    end
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @user_session }
    end
  end

  # POST /user_sessions
  # POST /user_sessions.xml
  def create
    phone_number = params[:user_session][:phone_number]
    user = User.find_by_phone_number(phone_number)
    if !user
      user = User.find_by_phone_number(get_modified_phone_number(phone_number))
      if user
        phone_number = user.phone_number
      end
    end

    # Fix variable phone format
    params[:user_session][:phone_number] = phone_number

    @user_session = UserSession.new(params[:user_session])

    respond_to do |format|
      if @user_session.save

        format.html {redirect_to "/close_fancybox"}
        format.xml  { render :xml => @user_session, :status => :created, :location => @user_session }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @user_session.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /user_sessions/1
  # DELETE /user_sessions/1.xml
  def destroy
    @user_session = UserSession.find
    if @user_session
      @user_session.destroy
    end

    respond_to do |format|
      format.html { redirect_to('/', :notice => 'Goodbye!') }
      format.xml  { head :ok }
    end
  end
end

private

def get_modified_phone_number(phone_number)
  if phone_number[0,1] == 1
    return phone_number[1..-1]
  else
    return '1' + phone_number
  end
end

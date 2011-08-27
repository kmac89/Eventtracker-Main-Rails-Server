class UsersController < ApplicationController
  skip_before_filter :verify_authenticity_token

  # GET /users
  # GET /users.xml
  def index
    @users = User.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @users }
    end
  end

  # GET /users/1
  # GET /users/1.xml
  def show
    if params[:id] then
      @user = User.find(params[:id])
    else
      @user = User.find_by_phone_number(params[:phone_number])
    end

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @user }
    end
  end

  # GET /users/new
  # GET /users/new.xml
  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @user }
    end
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
  end

  # POST /users
  # POST /users.xml
  def create
    @user = User.new(params[:user])
    debugger

    respond_to do |format|
      if @user.save
        format.html { redirect_to(@user, :notice => 'User was successfully created.') }
        format.xml  { render :xml => @user, :status => :created, :location => @user }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.xml
  def update
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to(@user, :notice => 'User was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.xml
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to(users_url) }
      format.xml  { head :ok }
    end
  end
  
  def init
    # todo authenticate
    @user = User.find_or_create_by_phone_number(params[:phone_number])
    @user.uuid = params[:uuid]
    @user.password = params[:password]

    #respond_to do |format|
      if @user.save
        render :text => 'OK', :status => 201
      else
        render :text => @user.errors, :status => 400
      end
    #end
  end

  def check_phone_number
    @user = User.find_by_phone_number(params[:phone_number])

    if @user.nil?
      # No account exists with this phone number
      render :text => 'false', :status => 201
    else
      # account exists with this phone number
      render :text => 'true', :status => 201
    end
  end

  def verify_password
    @user = User.find_by_phone_number(params[:phone_number])
    if @user.valid_password? params[:password]
      # account exists with this phone number and passwords match
      response = {'uuid' => @user.uuid, 'status' => 'verified'}
      render :json => response, :status => 201 
    else
      # passwords dont match
      response = {'status' => 'unverified'}
      render :json => response , :status => 201
    end
  end
end

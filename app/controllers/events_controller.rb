class EventsController < ApplicationController
  skip_before_filter :verify_authenticity_token

  # GET /events
  # GET /events.xml
  def index
    @events = Event.all 

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @events }
    end
  end

  # GET /:phone_number
  def table
    phone_number = params[:phone_number]
    @user = User.find_by_phone_number(phone_number)
    @user = User.find_by_phone_number(get_modified_phone_number(phone_number)) unless @user
    if !@user
      redirect_to '/', :notice => "Please log in with your phone number."
      return
    elsif !verify_user(@user)
      return
    end
    @events = Event.find(:all, :conditions => {:user_id => @user.id, :deleted => false}) unless @user.nil?

    @contents = @events.collect {|event|
	event.content
    }
    @contents = @contents.to_json

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @events }
    end
  end

  # GET /:phone_number/charts
  def charts
    @user = User.find_by_phone_number(params[:phone_number])
    if !verify_user(@user)
      return
    end
    @events = Event.find(:all, :conditions => {:user_id => @user.id, :deleted => false}) unless @user.nil?
    @contents = @events.collect {|event|
     # ActiveSupport::JSON.decode(event.content)
	event.content
    }
    @contents = @contents.to_json


    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @events }
    end
  end

  # GET /:phone_number/calendar
  def calendar
    @user = User.find_by_phone_number(params[:phone_number])
    if !verify_user(@user)
      return
    end
    @events = Event.find(:all, :conditions => {:user_id => @user.id, :deleted => false}) unless @user.nil?
    @contents = @events.collect {|event|
     # ActiveSupport::JSON.decode(event.content)
	event
    }
    @contents = @contents.to_json


    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @events }
    end
  end
  
  
  
# GET /:phone_number/timeline
  def timeline
    @user = User.find_by_phone_number(params[:phone_number])
    if !verify_user(@user)
      return
    end
    @events = Event.find(:all, :conditions => {:user_id => @user.id, :deleted => false}) unless @user.nil?
    @contents = @events.collect {|event|
     # ActiveSupport::JSON.decode(event.content)
	event
    }
    @contents = @contents.to_json


    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @events }
    end
  end

  def poll
    if params['PollTime']
      previous_poll_time = DateTime.parse(params['PollTime'])
      puts previous_poll_time
    end
    user = User.find_by_uuid(params['uuid'])
    if previous_poll_time then
      events = Event.find( :all, :conditions => ["updated_at > ? AND user_id = ?", previous_poll_time, user.id] )
    else
      events = Event.where(:user_id => user.id)
    end
    events_to_send = events.collect do |event|
	   event_data = {}
       event_data['content'] = event.content
       event_data['uuid'] = event.uuid
       event_data['updated_at'] = event.updated_at.to_s
       event_data['deleted'] = event.deleted
       event_data
    end

    response = {'pollTime' => DateTime.now, 'events' => events_to_send }

    render :json => response, :status => 200
  end

  # GET /events/map/:phone_number
  def map
    @event = Event.find(params[:id])
    @contents = @event.content.to_json
    @user = User.find(@event.user_id)
    if !verify_user(@user)
      return
    end
  end

  # GET /events/1
  # GET /events/1.xml
  def show
    @event = Event.find(params[:id])

    @content = ActiveSupport::JSON.decode(@event.content)

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @event }
    end
  end

  # GET /events/new
  # GET /events/new.xml
  def new
    @event = Event.new
    @user = User.find_by_phone_number(params[:phone_number])
    if !verify_user(@user)
      return
    end
    @event.user_id = @user.id
    @edit_fields = {'name' => 'Name', 'tag' => 'Category', 'notes' => 'Notes', 'startTime' => 'Start Time'}

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @event }
    end
  end

  # GET /events/1/edit
  def edit
    @event = Event.find(params[:id])
    @user = User.find(@event.user_id)
    if !verify_user(@user)
      return
    end
    @contents = @event.content.to_json
    @edit_fields = {'name' => 'Name', 'tag' => 'Category', 'notes' => 'Notes', 'startTime' => 'Start Time'}
  end

  # POST /events
  # POST /events.xml
  def create
    if params[:event]
      raise Exception
      #@event = Event.find(params[:event])
    else
      @event = Event.new
      @event.user_id = params[:user][:id]
    end
    if params[:content][:b]
      @event.content = params[:content][:b]
    end

    user = User.find(@event.user_id)
    @edit_fields = {'name' => 'Name', 'startTime' => 'Start Time', 'endTime' => 'End Time', 'notes' => 'Notes'}


    respond_to do |format|
      if @event.save
#        format.html { redirect_to("/#{user.phone_number}", :notice => 'Event was successfully created.') }
        format.html { redirect_to "/close_fancybox" }
        format.xml  { head :ok }
      else
        @contents = contents.to_json
        format.html { render :action => "edit" }
        format.xml  { render :xml => event.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /events/1
  # PUT /events/1.xml
  def update
    event = Event.find(params[:id])
    event.content = params['content']['b']

    user = User.find_by_id(params['user']['id'])
    if !verify_user(user)
      return
    end

    respond_to do |format|
      if event.save
        #format.html { redirect_to("/#{user.phone_number}", :notice => 'Event was successfully updated.') }
        format.html { redirect_to '/close_fancybox' }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => event.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1
  # DELETE /events/1.xml
  def destroy
    event = Event.find(params[:id])
    user = User.find(event.user_id)

    if !verify_user(user)
      return
    end
    event.deleted = true
    event.save
	
    respond_to do |format|
      format.html { redirect_to(:back) }
      format.xml  { head :ok }
    end
  end

  # DELETE /events/delete
  # user from phone for non-html response
  def delete
    uuid = params[:UUIDOfEvent]
    user_uuid = params[:uuid]
    errors = false
    if uuid and user_uuid then
      @event = Event.find_by_uuid(uuid)
      # user_uuid must match
      if @event
        errors = @event.user_id == User.find_by_uuid(user_uuid)
      else
        errors = true
      end
    else
      # must pass uuid and device uuid
      errors = true
    end
    @event.deleted = true

    if errors or !@event.save
      render :text => 'Could not delete', :status => 400
    else
      render :text => 'OK', :status => 200
    end
  end

  # POST /events/upload
  def upload
    @event = Event.find_or_create_by_uuid(params[:UUIDOfEvent])
    user = User.find_by_uuid(params[:uuid])
    @event.user_id = user.id unless user.nil?
    @event.content = params[:EventData]
    @event.deleted = params[:Deleted]
    phone_event_updated_at = DateTime.parse(params[:UpdatedAt])

    if @event.persisted?
      event_older = phone_event_updated_at < @event.updated_at
    end

    if event_older or @event.save
      render :text => 'OK', :status => 200
    else
      puts @event.errors
      render :text => @event.errors.to_s, :status => 400
    end
  end


  # POST /events/upload_bulk
  def upload_bulk
    event_data = ActiveSupport::JSON.decode(params[:EventData])

    user = User.find_by_uuid(params[:uuid])

    event_data.each do |event_datum|
      event = Event.find_or_create_by_uuid(event_datum["UUIDOfEvent"])
      event.user_id = user.id unless user.nil?
      event.content = event_datum["EventData"]
      event.deleted = event_datum["Deleted"]
      phone_event_updated_at = DateTime.parse(event_datum["UpdatedAt"])

      if event.persisted?
        event_older = phone_event_updated_at < event.updated_at
      end

      if !(event_older or event.save)
        render :text => event.errors.to_s, :status => 400
        return
      end
    end

    render :text => 'OK', :status => 200
  end

  private

  def verify_user(user)
    if !current_user || current_user.phone_number != user.phone_number
      redirect_to "/"
      return false
    end
    return true
  end

  def get_modified_phone_number(phone_number)
    if phone_number[0,1] == 1
      return phone_number[1..-1]
    else
      return '1' + phone_number
    end
  end
end

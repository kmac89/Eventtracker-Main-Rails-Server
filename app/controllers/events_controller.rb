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
    @user = User.find_by_phone_number(params[:phone_number])
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

  def poll
    if params['PollTime']
      previous_poll_time = DateTime.parse(params['PollTime'])
      puts previous_poll_time
    end
    user = User.find_by_uuid(params['UUIDOfDevice'])
    if previous_poll_time then
      events = Event.find( :all, :conditions => ["updated_at > ? AND user_id = ?", previous_poll_time, user.id] )
    else
      events = Event.where(:user_id => user.id)
    end
    events_to_send = events.collect do |event|
      event_contents = ActiveSupport::JSON.decode(event.content)
      event_contents['uuid'] = event.uuid
      event_contents['updated_at'] = event.updated_at.to_s
      event_contents['deleted'] = event.deleted
      event_contents
    end

    response = {'pollTime' => DateTime.now, 'events' => events_to_send }

    render :json => response, :status => 200
  end

  # GET /events/map/:phone_number
  def map
    @event = Event.find(params[:id])
    @contents = @event.content.to_json	
    @user = User.find(@event.user_id)
   # @contents = ActiveSupport::JSON.decode(@event.content)
  #  @gps_coords = @contents['gpsCoordinates']
#    if @gps_coords.nil? then
#      @gps_coords = []
#    end
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
    @event.user_id = @user.id
    @content = {}
    @contents = @event.content.to_json		
    @edit_fields = {'name' => 'Name', 'startTime' => 'Start Time', 'endTime' => 'End Time', 'notes' => 'Notes'}

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @event }
    end
  end

  # GET /events/1/edit
  def edit
    @event = Event.find(params[:id])
    @user = User.find(@event.user_id)
    @contents = @event.content.to_json	
    # @content = ActiveSupport::JSON.decode(@event.content)
    # ['startTime', 'endTime'].each do |time_key|
    # @content[time_key] = Event.time_long_to_s(@content[time_key])
    #end
    @edit_fields = {'name' => 'Name', 'startTime' => 'Start Time', 'endTime' => 'End Time', 'notes' => 'Notes'}
  end

  # POST /events
  # POST /events.xml
  def create
    if params[:event]
      @event = Event.find(params[:event])
    else
      @event = Event.new
      @event.user_id = params[:user][:id]
    end
    if @event.content
      @content = ActiveSupport::JSON.decode(@event.content)
    else
      @content = {}
    end
    params['content'].each do |key, value|
      if ['startTime', 'endTime'].include?(key)
        @content[key] = Event.time_s_to_long(value)
      else
        @content[key] = value
      end
    end unless params['content'].nil?
    @event.content = ActiveSupport::JSON.encode(@content)

    user = User.find(@event.user_id)
    @edit_fields = {'name' => 'Name', 'startTime' => 'Start Time', 'endTime' => 'End Time', 'notes' => 'Notes'}


    respond_to do |format|
      if @event.save
        format.html { redirect_to("/#{user.phone_number}", :notice => 'Event was successfully created.') }
        format.xml  { head :ok }
      else
        @content['startTime'] = params['content']['startTime']
        @content['endTime'] = params['content']['endTime']
        format.html { render :action => "edit" }
        format.xml  { render :xml => event.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /events/1
  # PUT /events/1.xml
  def update
    event = Event.find(params[:id])
    event.content = params['content']['b'] # the b part is a temp hack- I think this should work given the params that are passed....

    user = User.find(event.user_id)

    respond_to do |format|
      if event.save
        format.html { redirect_to("/#{user.phone_number}", :notice => 'Event was successfully updated.') }
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
    event.deleted = true
    event.save

    respond_to do |format|
      format.html { redirect_to("/#{user.phone_number}") }
      format.xml  { head :ok }
    end
  end

  # DELETE /events/delete
  # user from phone for non-html response
  def delete
    uuid = params[:UUIDOfEvent]
    user_uuid = params[:UUIDOfDevice]
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
    user = User.find_by_uuid(params[:UUIDOfDevice])
    @event.user_id = user.id unless user.nil?
    @event.content = params[:EventData]
    @event.deleted = params[:Deleted]
    phone_updated_at = DateTime.parse(params[:UpdatedAt])

    if @event.persisted?
      event_older = phone_updated_at < @event.updated_at
    end

    if event_older or @event.save
      render :text => 'OK', :status => 200
    else
      puts @event.errors
      render :text => @event.errors.to_s, :status => 400
    end
  end

end

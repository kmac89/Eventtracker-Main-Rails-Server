class EventsController < ApplicationController
  skip_before_filter :verify_authenticity_token, :only => [:poll,:upload_bulk, :delete]
  skip_before_filter :set_csp, :only => :charts
  before_filter :set_local_csp, :only => :charts

  # Sets the content security policy by modifying the http headers
  def set_local_csp
    response.headers['X-Content-Security-Policy'] = "default-src 'self'; script-src 'self' https://www.google.com; options inline-script eval-script; report-uri http://127.0.0.1:3000/csp_report"
  end
  # GET /:phone_number/table
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
      format.json { render :json => {:contents => @events.as_json}}
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

  # The root of the site is routed to this action
  def calendar
    if current_user
	  current_phone_number = current_user.phone_number
	end
    @user = User.find_by_phone_number(params[:phone_number]) || User.find_by_phone_number(current_phone_number)
    if !verify_user_calendar(@user)
      @user = User.new
	  @user.phone_number = "123456" #dummy phone number
	  @events=[]
	  @contents=[]
	  #used for displaying the login box in the calendar view
	  @need_to_login = true
	else
	  @need_to_login = false
      @events = Event.find(:all, :conditions => {:user_id => @user.id, :deleted => false}) unless @user.nil?
      @contents = @events.collect {|event|
       # ActiveSupport::JSON.decode(event.content)
	    event
      }
      @contents = @contents.to_json
	end


    respond_to do |format|
      format.json { render :json => {:phone_number => @user.phone_number, :contents => @events.as_json, :need_to_login => @need_to_login }}
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
      # TODO fix this bad code/ordering
    end
    user = User.find_by_uuid(params['uuid'])
    if previous_poll_time then
      events = Event.find( :all, :conditions => ["updated_at > ? AND user_id = ?", previous_poll_time, user.id] )
    else
      events = Event.find(:all, :conditions => {:user_id => user.id, :deleted => false})
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
    @user = User.find(@event.user_id)
    if !verify_user(@user)
      return
    end
    @contents = @event.content.to_json
    @edit_fields = {'name' => 'Name', 'tag' => 'Category', 'notes' => 'Notes', 'startTime' => 'Start Time'}
    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => {:contents => @event.as_json}}
      format.xml  { render :xml => @event }
    end
  end

  # GET /:phone_number/new
  # This is called when a new event is being created
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
      format.json { render :json => {:contents => nil}}
      format.xml  { render :xml => @event }
    end
  end

  # GET /events/1/edit
  # Called when an event is being edited
  def edit
    logger.debug "edit"
    @event = Event.find(params[:id])
    @user = User.find(@event.user_id)
    if !verify_user(@user)
      return
    end
    @contents = @event.content.to_json
    @edit_fields = {'name' => 'Name', 'tag' => 'Category', 'notes' => 'Notes', 'startTime' => 'Start Time'}
    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => {:contents => @event.as_json}}
      format.xml  { render :xml => @event }
    end
  end

  # POST /events
  # POST /events.xml
  # This method is called when the form for creating an event is submitted
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
    if !verify_user(user)
      return
    end
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

  # POST /events/1
  # This method is called when the form for creating an event is submitted
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
  # Called from the phone when the user has deleted an event
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

  # POST /events/upload_bulk
  def upload_bulk
    event_data = ActiveSupport::JSON.decode(params[:EventData])

    user = User.find_by_uuid(params[:uuid])

    event_data.each do |event_datum|
      event = Event.find_or_create_by_uuid(event_datum["UUIDOfEvent"])
      if received_event_outdated?(event_datum, event)
        success = true
      else
        event.user_id = user.id unless user.nil?
        event.content = event_datum["EventData"]
        event.deleted = event_datum["Deleted"]
        event.updated_at = DateTime.parse(event_datum["UpdatedAt"])
        success = event.save
      end

      if !success
        render :text => event.errors.to_s, :status => 400
        return
      end
    end

    render :text => 'OK', :status => 200
  end

  private

  def verify_user_calendar(user)
    if !current_user || current_user.phone_number != user.phone_number
      return false
    end
    return true
  end

  # Returns true if the received event data is outdated, otherwise false.
  def received_event_outdated?(received_datum, existing_event)
    if !existing_event.persisted?
      return false # if there was no previous event, this is new data
    else
      received_event_updated_at = DateTime.parse(received_datum["UpdatedAt"])
      return received_event_updated_at < existing_event.updated_at
    end
  end

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

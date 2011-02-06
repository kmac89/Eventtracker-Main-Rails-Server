class EventsController < ApplicationController
  skip_before_filter :verify_authenticity_token

  # GET /events
  # GET /events.xml
  def index
    @events =
      if params[:phone_number] then
        user = User.find_by_phone_number(params[:phone_number])
        Event.find_all_by_user_id(user.id) unless user.nil?
      else
        Event.all 
      end
   

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @events }
    end
  end

  # GET /events/1
  # GET /events/1.xml
  def show
    @event = Event.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @event }
    end
  end

  # GET /events/new
  # GET /events/new.xml
  def new
    @event = Event.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @event }
    end
  end

  # GET /events/1/edit
  def edit
    @event = Event.find(params[:id])
  end

  # POST /events
  # POST /events.xml
  def create
    @event = Event.new(params[:event])

    respond_to do |format|
      if @event.save
        format.html { redirect_to(@event, :notice => 'Event was successfully created.') }
        format.xml  { render :xml => @event, :status => :created, :location => @event }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @event.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /events/1
  # PUT /events/1.xml
  def update
    @event = Event.find(params[:id])

    respond_to do |format|
      if @event.update_attributes(params[:event])
        format.html { redirect_to(@event, :notice => 'Event was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @event.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1
  # DELETE /events/1.xml
  def destroy
    errors = false
    if params[:id] then
      @event = Event.find(params[:id])
    else 
      # delete by uuid and device uuid
      uuid = params[:UUIDOfEvent]
      user_uuid = params[:UUIDOfDevice]
      if uuid and user_uuid then
        @event = Event.find_by_uuid(uuid)
        # user_uuid must match
        errors = @event.user_id == User.find_by_uuid(user_uuid)
      else
        # must pass uuid and device uuid
        errors = true
      end
    end
    @event.destroy unless errors

    respond_to do |format|
      if !errors then
        format.html { redirect_to(events_url) }
        format.xml  { head :ok }
      else
        format.html { redirect_to(events_url, :notice => 'Could not destroy event') }
        format.xml  { head :ok }
      end
    end
  end

  # POST /events/upload
  # POST /events/upload.xml
  def upload
    @event = Event.find_or_create_by_uuid(params[:UUIDOfEvent])
    user = User.find_by_uuid(params[:UUIDOfDevice])
    @event.user_id = user.id unless user.nil?
    @event.uuid = params[:UUIDOfEvent]
    @event.content = params[:EventData]

    respond_to do |format|
      if @event.save
        format.html { redirect_to(@event, :notice => 'Event was successfully created.') }
        format.xml  { render :xml => @event, :status => :created, :location => @event }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @event.errors, :status => :unprocessable_entity }
      end
    end
  end

end

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

  # GET /events/phone/:phone_number
  def user
    @user = User.find_by_phone_number(params[:phone_number])
    @events = Event.find_all_by_user_id(@user.id) unless @user.nil?

    @event_content_pairs = 
      @events.collect {|event|
        json_data = ActiveSupport::JSON.decode(event.content)
        ['startTime', 'endTime'].each do |time|
          if json_data[time]
            epoch_time = Time.at(json_data[time] / 1000)
            json_data[time] = epoch_time.strftime('%I:%M%p %m-%d-%y')
          end
        end
        [event, json_data]
    }

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @events }
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
    event = Event.find(params[:id])
    user = User.find(event.user_id)
    event.destroy

    respond_to do |format|
      format.html { redirect_to("/events/phone/#{user.phone_number}") }
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
      errors = @event.user_id == User.find_by_uuid(user_uuid)
    else
      # must pass uuid and device uuid
      errors = true
    end

    if errors
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

    if @event.save
      render :text => 'OK', :status => 200
    else
      render :text => @event.errors.to_s, :status => 400
    end
  end

end

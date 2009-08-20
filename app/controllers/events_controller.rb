class EventsController < ApplicationController
  # FIXME anyone user can edit locations and there's no versioning, which is bad
  
  before_filter :require_user, :only => [:new, :create, :edit, :update, :destroy]
  before_filter :assign_event_or_redirect, :only => [:show, :edit, :update, :destroy]
  before_filter :assign_locations, :only => [:new, :edit]

  # GET /events
  # GET /events.xml
  def index
    events_callback = lambda { Event.paginate(:page => params[:page], :order => 'ends_at desc') }

    respond_to do |format|
      format.ics {
        @events = Event.recent
        render :text => Event.to_icalendar(@events)
      }
      format.html { 
        # index.html.erb 
        @events = events_callback.call
      }
      format.xml  { 
        @events = events_callback.call
        render :xml => @events 
      }
    end
  end

  # GET /events/1
  # GET /events/1.xml
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @event }
    end
  end

  # GET /events/new
  # GET /events/new.xml
  def new
    @event = Event.new
    @location = Location.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @event }
    end
  end

  # GET /events/1/edit
  def edit
  end

  # POST /events
  # POST /events.xml
  def create
    @event = Event.new(params[:event])
    @location = nil
    @event.member = current_user

    if params[:location]
      @location = Location.new(params[:location])
      @event.location = @location
    end

    respond_to do |format|
      if (@location ? @location.save : true) and @event.save
        flash[:notice] = 'Event was successfully created.'
        format.html { redirect_to(@event) }
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
    respond_to do |format|
      if @event.update_attributes(params[:event])
        flash[:notice] = 'Event was successfully updated.'
        format.html { redirect_to(@event) }
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
    @event.destroy

    respond_to do |format|
      format.html { redirect_to(events_path) }
      format.xml  { head :ok }
    end
  end

  def add_location
    render :layout => false
  end

protected

  def assign_event_or_redirect
    begin
      @event = Event.find(params[:id])
      return false
    rescue ActiveRecord::RecordNotFound => e
      flash[:notice] = "No such event, it may have been deleted."
      return redirect_back_or_default(events_path)
    end
  end

  def assign_locations
    @locations = Location.all
  end

end

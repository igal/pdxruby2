class EventsController < ApplicationController
  before_filter :require_user, :only => [:new, :create, :edit, :update, :destroy]
  before_filter :assign_event_or_redirect, :only => [:show, :edit, :update, :destroy]
  before_filter :require_authorization, :only => [:edit, :update, :destroy]
  before_filter :assign_locations, :only => [:new, :edit]

  # GET /events
  # GET /events.xml
  def index
    @events = Defer { ::Event.paginate(:page => params[:page], :order => 'ends_at desc') }

    respond_to do |format|
      format.ics  { render :text => Event.to_icalendar(@events) }
      format.atom # index.atom.builder
      format.html # index.html.erb
      format.xml  { render :xml => @events }
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
    @event = params[:clone] ? Event.clone_from(params[:clone]) : Event.new
    @location = @event.location ? @event.location : Location.new

    flash[:notice] = 'This event is cloned from a past event, be sure to update its fields!' if params[:clone]

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

  def require_authorization
    if @event.can_alter?(current_user)
      return false
    else
      flash[:notice] = "You are not allowed to edit this event."
      return redirect_back_or_default(event_path(@event))
    end
  end
end

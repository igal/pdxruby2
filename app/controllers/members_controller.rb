class MembersController < ApplicationController
  before_filter :require_user, :only => [:index, :show, :edit, :update, :destroy]
  before_filter :assign_user, :only => [:show, :edit, :update, :destroy]
  before_filter :require_privileges_for_user, :only => [:edit, :update, :destroy]

  # GET /members
  # GET /members.xml
  def index
    @members = Member.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @members }
    end
  end

  # GET /members/1
  # GET /members/1.xml
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @member }
    end
  end

  # GET /members/new
  # GET /members/new.xml
  def new
    @member = Member.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @member }
    end
  end

  # GET /members/1/edit
  def edit
    @member = Member.find(params[:id])
  end

  # POST /members
  # POST /members.xml
  def create
    @member = Member.new(params[:member])

    if params[:member_password] == params[:member_verify_password]
      @member.password = params[:member_password]
    else
      flash[:notice] = "ERROR: Passwords were not the same."
      render :action => "new"
      return false
    end

    respond_to do |format|
      if @member.save
        flash[:notice] = 'Member was successfully created.'
        format.html { redirect_to(@member) }
        format.xml  { render :xml => @member, :status => :created, :location => @member }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @member.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /members/1
  # PUT /members/1.xml
  def update
    if params[:member_password]
      if params[:member_password] == params[:member_verify_password]
        @member.password = params[:member_password]
      else
        flash[:notice] = "ERROR: Passwords were not the same."
        render :action => "edit"
        return false
      end
    end

    respond_to do |format|
      if @member.update_attributes(params[:member])
        flash[:notice] = 'Member was successfully updated.'
        format.html { redirect_to(@member) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @member.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /members/1
  # DELETE /members/1.xml
  def destroy
    @member.destroy

    respond_to do |format|
      format.html { redirect_to(members_url) }
      format.xml  { head :ok }
    end
  end

protected

  def assign_user
    @member = Member.find_by_id(params[:id])
    if @member
      return false
    else
      flash[:notice] = "Member not found, maybe they were deleted."
      return redirect_back_or_default(members_path)
    end
  end

  def require_privileges_for_user
    if current_user == @member
      return false
    else
      flash[:notice] = "You are not allowed to edit this user's account"
      return redirect_back_or_default(members_path)
    end
  end
end

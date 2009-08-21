class MembersController < ApplicationController
  before_filter :require_user, :only => [:edit, :update, :destroy]
  before_filter :assign_user_or_redirect, :only => [:show, :edit, :update, :destroy]
  before_filter :require_authorization, :only => [:edit, :update, :destroy]

  # GET /members
  # GET /members.xml
  def index
    @members = Defer { ::Member.all }

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

    if logged_in? && current_user.admin?
      @member.admin = params[:member][:admin]
    end

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
        format.html { redirect_to(member_path(@member)) }
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
    if current_user.admin?
      @member.admin = params[:member][:admin]
    end

    unless params[:member_password].blank?
      if params[:member_password] == params[:member_verify_password]
        @member.password = params[:member_password]
      else
        flash[:notice] = "ERROR: Passwords were not the same."
        render :action => "edit"
        return
      end
    end

    respond_to do |format|
      if @member.update_attributes(params[:member])
        flash[:notice] = 'Member was successfully updated.'
        format.html { redirect_to(member_path(@member)) }
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
      flash[:notice] = "Destroyed user"
      format.html { redirect_to(members_url) }
      format.xml  { head :ok }
    end
  end

protected

  def assign_user_or_redirect
    begin
      @member = Member.find(params[:id])
      return false
    rescue ActiveRecord::RecordNotFound => e
      flash[:notice] = "Member not found, maybe they were deleted."
      return redirect_back_or_default(members_path)
    end
  end

  def require_authorization
    if @member.can_alter?(current_user)
      return false
    else
      flash[:notice] = "You are not allowed to edit this user's account"
      return redirect_back_or_default(member_path(@member))
    end
  end
end

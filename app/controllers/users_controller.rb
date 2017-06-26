class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  # GET /users/1
  # GET /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
      params.require(:user).permit(:name, :fb_id)
      username = params[:user][:name]
      fb_id = params[:user][:fb_id]


      #respond_to do |format| 
      #check if the user is already in the database
      if User.where(:fb_id => fb_id).exists?
          @user = User.where(["fb_id = ?", fb_id]).first
          #redirect_to @user and return
          puts "User #{@user.name} already exists in the db"

          url = url_for :controller => 'users', :action => 'show', :id => @user.id
          data = {url: url} 
          puts 'sending to client'
            
          render :json => data
          puts 'after sending to client'
          #format.html { redirect_to @user, notice: 'User has already been created' }
          #format.json { redirect_to @user, notice: 'User has already been created' }
          #format.json { render :show, status: :created, location: @user }
          #here we need to go to a new page
          #Possibly need to send the url necessary back to the js

      else
          #create a new user
          @user = User.new(user_params)

          if @user.save
              format.html { redirect_to @user, notice: 'User was successfully created.' }
              format.json { render :show, status: :created, location: @user }
          else
              format.html { render :new }
              format.json { render json: @user.errors, status: :unprocessable_entity }
          end
      end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.fetch(:user, {})
    end
end

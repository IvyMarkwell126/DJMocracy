class PartyUsersController < ApplicationController
  before_action :set_party_user, only: [:show, :edit, :update, :destroy]

  # GET /party_users
  # GET /party_users.json
  def index
    @party_users = PartyUser.all
  end

  # GET /party_users/1
  # GET /party_users/1.json
  def show
  end

  # GET /party_users/new
  def new
    @user = User.find(params[:user_id])
    @party_user = PartyUser.new
  end

  # GET /party_users/1/edit
  def edit
  end

  # POST /party_users
  # POST /party_users.json
  def create
    user_id = params[:user_id]
    @user = User.find(user_id) 
    @party_user = PartyUser.new(party_id: params[:party_id], user_id: user_id)
    respond_to do |format|
      if @party_user.save
        format.html { redirect_to @user, notice: 'Party user was successfully created.' }
        format.json { render :show, status: :created, location: @party_user }
      else
        format.html { render :new }
        format.json { render json: @party_user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /party_users/1
  # PATCH/PUT /party_users/1.json
  def update
    respond_to do |format|
      if @party_user.update(party_user_params)
        format.html { redirect_to @party_user, notice: 'Party user was successfully updated.' }
        format.json { render :show, status: :ok, location: @party_user }
      else
        format.html { render :edit }
        format.json { render json: @party_user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /party_users/1
  # DELETE /party_users/1.json
  def destroy
    @party_user.destroy
    respond_to do |format|
      format.html { redirect_to party_users_url, notice: 'Party user was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_party_user
      @party_user = PartyUser.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def party_user_params
      #params.require(:party_user).permit(:party_id)
      params.require(:party_id)
    end
end

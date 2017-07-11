class PartySongsController < ApplicationController
  before_action :set_party_song, only: [:show, :edit, :update, :destroy]

  # GET /party_songs
  # GET /party_songs.json
  def index
    @party_songs = PartySong.all
  end

  # GET /party_songs/1
  # GET /party_songs/1.json
  def show
  end

  # GET /party_songs/new
  def new
    @party_song = PartySong.new
    @data = Song.all
    @party = Party.find(params[:party_id])
    @user = User.find(params[:user_id])
  end

  # GET /party_songs/1/edit
  def edit
  end

  # POST /party_songs
  # POST /party_songs.json
  def create
    #@party_song = PartySong.new(party_song_params)

    genre = params[:genre]
    year = params[:start_date]['start_date(1i)']
    month = normalize_date(params[:start_date]['start_date(2i)'])
    day = normalize_date(params[:start_date]['start_date(3i)'])
    party_id = params[:party_id]
    user_id = params[:user_id]
    date = "#{year}-#{month}-#{day}"

    PartySong.import_from_billboard(genre, date, party_id)
    redirect_to user_party_path(user_id, party_id)

  end

  # PATCH/PUT /party_songs/1
  # PATCH/PUT /party_songs/1.json
  def update
    respond_to do |format|
      if @party_song.update(party_song_params)
        format.html { redirect_to @party_song, notice: 'Party song was successfully updated.' }
        format.json { render :show, status: :ok, location: @party_song }
      else
        format.html { render :edit }
        format.json { render json: @party_song.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /party_songs/1
  # DELETE /party_songs/1.json
  def destroy
    @party_song.destroy
    respond_to do |format|
      format.html { redirect_to party_songs_url, notice: 'Party song was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_party_song
      @party_song = PartySong.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def party_song_params
      params.permit(:genre, :date)
    end

    def normalize_date(input) 
      if input.to_i < 10
        return "0#{input.to_s}"
      else
        return input.to_s
      end
    end
end

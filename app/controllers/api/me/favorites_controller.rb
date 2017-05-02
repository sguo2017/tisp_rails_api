class Api::Me::FavoritesController < ApplicationController

  respond_to :json

  before_filter :authenticate_user_from_token!

  before_action :set_favorite, only: [:show, :edit, :update, :destroy]

  # GET /favorites
  # GET /favorites.json
  def index
   #@favorites = Favorite.order("created_at DESC").page(params[:page]).per(5)
    token = params[:token].presence
    user = token && User.find_by_authentication_token(token.to_s)
    user_id = user.id
    @favorites = Favorite.where(user_id: user_id).order("created_at DESC").page(params[:page]).per(5)
    #@favorites = Favorite.order("created_at DESC").page(params[:page]).per(5)
    
    @offers = []
    @favorites.each do |favorite|
         offer = Good.find(favorite.obj_id)
         s = offer.attributes.clone
        logger.debug "s:#{s.to_s}"
	 begin
            u = User.find(offer.user_id)
            u.authentication_token = "***"
            s["user"]=u
	 rescue ActiveRecord::RecordNotFound => e
         
	 end
         s["isFavorited"] = true
         s["favorite_id"] = favorite.id.to_s
         @offers.push(s)
    end

    logger.debug "offers:#{@offers.to_json}"

    respond_to do |format|
      format.json {
        logger.debug "sysMsg index json"
        render json: {page: "1",total_pages: "7", feeds: @offers.to_json}
      }
    end
  end

  # GET /favorites/1
  # GET /favorites/1.json
  def show
  end

  # GET /favorites/new
  def new
    @favorite = Favorite.new
  end

  # GET /favorites/1/edit
  def edit
  end

  # POST /favorites
  # POST /favorites.json
  def create
    @favorite = Favorite.new(favorite_params)

    respond_to do |format|
      if @favorite.save
        format.html { redirect_to @favorite, notice: 'Favorite was successfully created.' }
        #format.json { render :show, status: :created, location: @favorite }
        format.json {
           render json: {status:0, msg:"success", favorite_id: @favorite.id}
        }
      else
        format.html { render :new }
        format.json { render json: @favorite.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /favorites/1
  # PATCH/PUT /favorites/1.json
  def update
    respond_to do |format|
      if @favorite.update(favorite_params)
        format.html { redirect_to @favorite, notice: 'Favorite was successfully updated.' }
        format.json { render :show, status: :ok, location: @favorite }
      else
        format.html { render :edit }
        format.json { render json: @favorite.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /favorites/1
  # DELETE /favorites/1.json
  def destroy
    @favorite.destroy
    respond_to do |format|
      format.html { redirect_to favorites_url, notice: 'Favorite was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_favorite
      @favorite = Favorite.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def favorite_params
      params.require(:favorite).permit(:obj_id, :obj_type, :user_id)
    end
end

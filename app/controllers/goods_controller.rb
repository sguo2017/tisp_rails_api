class GoodsController < ApplicationController

  #before_filter :authenticate_user_from_token!  

  #before_action :authenticate_user!

  before_filter :authenticate_user!

  before_action :set_good, only: [:show, :edit, :update, :destroy]
  
  before_action :set_goods_search

  #skip_before_filter :verify_authenticity_token

  # GET /goods
  # GET /goods.json
  def index
    @goods = Good.order("created_at DESC").page(params[:page]).per(10)
    logger.debug "good all!!! current_user:#{@current_user} #{current_user}"

    if @current_user 
       logger.debug 'come on'
    else
       logger.debug 'nil'
    end
 
    if user_signed_in?
      logger.debug 'siged_id!!!!!!'
    else
      logger.debug 'why?'
    end

    user = session[:current_tispr_user]
    logger.debug "good all!!! session.tispr_user.email: #{user['email']} session.tispr_user.id: #{user['id']}"    

  end


  # GET /goods/1
  # GET /goods/1.json
  def show
  end

  # GET /goods/new
  def new
    @good = Good.new
  end

  # GET /goods/1/edit
  def edit
  end

  # POST /goods
  # POST /goods.json
  def create
    @good = Good.new(good_params)
    @good.user_id = current_user.id    

    respond_to do |format|
      if @good.save
        format.html { redirect_to @good, notice: '成功创建商品！' }
        format.json { render :show, status: :created, location: @good }
      else
        format.html { render :new }
        format.json { render json: @good.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /goods/1
  # PATCH/PUT /goods/1.json
  def update
    respond_to do |format|
      if @good.update(good_params)
        format.html { redirect_to @good, notice: '成功更新商品！' }
        format.json { render :show, status: :ok, location: @good }
      else
        format.html { render :edit }
        format.json { render json: @good.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /goods/1
  # DELETE /goods/1.json
  def destroy
    @good.destroy
    respond_to do |format|
      format.html { redirect_to goods_url, notice: '成功删除商品！' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_good
      @good = Good.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def good_params
      params.require(:good).permit(:serv_title, :serv_detail, :serv_imges, :serv_catagory, :user_id)
    end
	
	def set_goods_search
	   if !@goods_search
	      @goods_search=GoodsSearch.new
	   end
	end
end

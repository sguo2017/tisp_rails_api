class GoodsController < ApplicationController

  #before_filter :authenticate_user_from_token!

  #before_action :authenticate_user!

  before_action :authenticate_user!

  before_action :set_good, only: [:edit, :update, :show, :destroy]

  before_action :set_goods_search

  before_action :set_list_for_select, only: [:new, :edit]

  load_and_authorize_resource :only => [:new, :create]

  #skip_before_filter :verify_authenticity_token

  # GET /goods
  # GET /goods.json
  def index
    @goods = Good.order("created_at DESC").page(params[:page]).per(10)
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
        @code = 200
        @msg = "success"
        format.json { render json: {status: :update, code: @code, msg: @msg} }
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
      params.require(:good).permit(:serv_title, :serv_detail, :serv_images, :serv_catagory, :user_id, :goods_catalog_id, :status)
    end

	def set_goods_search
	   if !@goods_search
	      @goods_search=GoodsSearch.new
	   end
	end

	def set_list_for_select
	  @catalog_list = GoodsCatalog.all.map{ |c| [c.name,c.id]}
    if @good.nil? or @good.goods_catalog.nil?
      @catalog_selected=[]
    else
      @catalog_selected=[@good.goods_catalog.name, @good.goods_catalog.id]
    end

    @catagory_list = Const::GOODS_TYPE.values.map { |v| [v, v] }
    if @good.nil? or @good.serv_catagory.nil?
      @catagory_selected=[]
    else
      @catagory_selected=@catagory_list.select{|a| a[0] == @good.serv_catagory}.first
    end
	end
end

class GoodsCatalogsController < ApplicationController
  before_action :set_goods_catalog, only: [:show, :edit, :update, :destroy]
  before_action :set_root_id
  load_and_authorize_resource

  # GET /goods_catalogs
  # GET /goods_catalogs.json
  def index
    @goods_catalogs = GoodsCatalog.order("created_at ASC").page(params[:page]).per(10)
  end

  # GET /goods_catalogs/1
  # GET /goods_catalogs/1.json
  def show
  end

  # GET /goods_catalogs/new
  def new
    @goods_catalog = GoodsCatalog.new
  end

  # GET /goods_catalogs/1/edit
  def edit
  end

  # POST /goods_catalogs
  # POST /goods_catalogs.json
  def create
    @goods_catalog = GoodsCatalog.new(goods_catalog_params)

    respond_to do |format|
      if @goods_catalog.save
        format.html { redirect_to @goods_catalog, notice: '成功创建商品分类！' }
        format.json { render :show, status: :created, location: @goods_catalog }
      else
        format.html { render :new }
        format.json { render json: @goods_catalog.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /goods_catalogs/1
  # PATCH/PUT /goods_catalogs/1.json
  def update
    respond_to do |format|
      if @goods_catalog.update(goods_catalog_params)
        format.html { redirect_to @goods_catalog, notice: '成功更新商品分类' }
        format.json { render :show, status: :ok, location: @goods_catalog }
      else
        format.html { render :edit }
        format.json { render json: @goods_catalog.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /goods_catalogs/1
  # DELETE /goods_catalogs/1.json
  def destroy
    if @goods_catalog.id == @root_id
	  respond_to do |format|
        format.html { redirect_to goods_catalogs_url, notice: '根节点不可删除！' }
      end
	else
      @goods_catalog.destroy
      respond_to do |format|
        format.html { redirect_to goods_catalogs_url, notice: '成功删除商品分类' }
        format.json { head :no_content }
      end
	end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_goods_catalog
      @goods_catalog = GoodsCatalog.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def goods_catalog_params
      params.require(:goods_catalog).permit(:name, :image, :level, :parent_id)
    end
	
	def set_root_id
	  @root_id = 1
	end
end

class GoodsCatalogsController < ApplicationController
  before_action :set_goods_catalog, only: [:show, :edit, :update, :destroy]

  # GET /goods_catalogs
  # GET /goods_catalogs.json
  def index
    @goods_catalogs = GoodsCatalog.all
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
        format.html { redirect_to @goods_catalog, notice: 'Goods catalog was successfully created.' }
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
        format.html { redirect_to @goods_catalog, notice: 'Goods catalog was successfully updated.' }
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
    @goods_catalog.destroy
    respond_to do |format|
      format.html { redirect_to goods_catalogs_url, notice: 'Goods catalog was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_goods_catalog
      @goods_catalog = GoodsCatalog.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def goods_catalog_params
      params.require(:goods_catalog).permit(:name, :image, :level)
    end
end

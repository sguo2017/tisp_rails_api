class Api::Goods::GoodsCatalogsController < ApplicationController
  respond_to :json

  before_action :authenticate_user_from_token!

  #before_action :set_goods_catalog, only: [:show, :edit, :update, :destroy]


  # GET /goods_catalogs
  # GET /goods_catalogs.json
  def index
    level = params[:level].presence
    unless level.blank?
    	@goods_catalogs = GoodsCatalog.where("level=?",params[:level]).order("created_at ASC")
    end
		goods_catalogs_arr = []
    @goods_catalogs.each do |catalog|
    	c = catalog.attributes.clone
    	parent_id = catalog.id
      
      #计算大分类的服务量和需求量
      c["goods_count"] = 0
      c["request_count"] = 0
    	goods_catalogs_II =  GoodsCatalog.where("ancestry=?","1/#{parent_id}").order("created_at ASC")
      goods_catalogs_II.each do |catalog_II|
        c_II = catalog_II.attributes.clone
        c["goods_count"] = c["goods_count"] + c_II["goods_count"]
        c["request_count"] = c["request_count"] +c_II["request_count"]
      end

    	if goods_catalogs_II.blank?
    		c["goods_catalogs_II"] = "[]"
    	else
    		c["goods_catalogs_II"] = goods_catalogs_II.to_json
      end
    	goods_catalogs_arr.push(c)
    end


    respond_to do |format|
        format.json {render json: {feeds: goods_catalogs_arr.to_json}}
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

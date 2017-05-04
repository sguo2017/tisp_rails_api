class Api::Goods::GoodsCatalogsController < ApplicationController
  respond_to :json

  before_filter :authenticate_user_from_token!

  #before_action :set_goods_catalog, only: [:show, :edit, :update, :destroy]
  
  
  # GET /goods_catalogs
  # GET /goods_catalogs.json
  def index
    level = params[:level].presence
    logger.debug "13:#{level}"
    unless level.blank?
    	@goods_catalogs = GoodsCatalog.where("level=?",params[:level]).order("created_at ASC")
    end
    logger.debug "15:#{@goods_catalogs.to_json}"
    parent_id = params[:parent_id].presence
    logger.debug "17:#{parent_id}"
    unless parent_id.blank? 
    	@goods_catalogs = GoodsCatalog.where("parent_id=?",params[:parent_id]).order("created_at ASC")
    end
    logger.debug "20:#{@goods_catalogs.to_json}"
    respond_to do |format|
        format.json {render json: {feeds: @goods_catalogs.to_json}}
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
        
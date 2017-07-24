class GoodsShowController < ActionController::Base
	def index
      @goods_show=Good.find(params[:id])
    end
end

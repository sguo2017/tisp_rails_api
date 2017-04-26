class Api::GoodsCatalogs::GoodsCatalogsController < ApplicationController
    def catalogs_json
	  json_string=GoodsCatalog.find(1).subtree.arrange_serializable.to_json
	  respond_to do |format|
      format.json {
        render json: json_string
      }
	  format.js {
        render json: json_string
      }
      end
	end
end

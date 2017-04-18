class ConditionsQueryController <  ApplicationController
   # GET/POST  /conditions_query/serv_offers
   def serv_offers
      id=params[:q_id]
      user_id=params[:q_user_id]
      serv_title=params[:q_serv_title]
      serv_detail=params[:q_serv_detail]
      created_at=params[:q_created_at]
      if (id+user_id+serv_title+serv_detail+created_at).empty?
          redirect_to '/'
      else
          if (id+user_id).empty?
            sql="serv_title like ? and serv_detail like ? and created_at like ? "
            @serv_offers=ServOffer.where(sql,"%"+serv_title+"%","%"+serv_detail+"%","%"+created_at+"%").order("created_at DESC").page(params[:page]).per(10)
          elsif id.empty?
            sql="user_id = ? and serv_title like ? and serv_detail like ? and created_at like ? "
            @serv_offers=ServOffer.where(sql,user_id,"%"+serv_title+"%","%"+serv_detail+"%","%"+created_at+"%").order("created_at DESC").page(params[:page]).per(10)
          elsif user_id.empty?
            sql="id = ? and serv_title like ? and serv_detail like ? and created_at like ? "
            @serv_offers=ServOffer.where(sql,id,"%"+serv_title+"%","%"+serv_detail+"%","%"+created_at+"%").order("created_at DESC").page(params[:page]).per(10)
          else
            sql="id = ? and user_id=? and serv_title like ? and serv_detail like ? and created_at like ? "
            @serv_offers=ServOffer.where(sql,id,user_id,"%"+serv_title+"%","%"+serv_detail+"%","%"+created_at+"%").order("created_at DESC").page(params[:page]).per(10)
          end
          @q_id=id
          @q_user_id=user_id
          @q_serv_title=serv_title
          @q_serv_detail=serv_detail
          @q_created_at=created_at
          render "serv_offers/index"
      end
   end
          

end




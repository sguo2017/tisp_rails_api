class Api::SysMsgsTimelines::SysMsgsQueriesController < ApplicationController

  respond_to :json
  before_action :authenticate_user_from_token!

  # GET /sys_msgs_queries
  def index
    query_type = params[:query_type]
    user_id = params[:user_id]
    return render json: {status: :failed,reason: :parameters_error} if !query_type or !user_id or !User.exists?(user_id)
    # 此处A的查询有很多种方法，可以混合使用inner join、in、exists等查询；例如
    # (1)
    # select * from sys_msgs S where S.msg_catalog = 'private' and exists
    # (select U2.id from users U1 inner join users U2 on U1.city = U2.city where U1.id =2 and U2.id = S.user_id)
    # (2)
    # SELECT  `sys_msgs`.* FROM `sys_msgs`
    # inner join ( SELECT `users`.* FROM `users`
    # inner join users U2 on U2.city = users.city WHERE `U2`.`id` = '2' ) T
    # on user_id = T.id WHERE `sys_msgs`.`msg_catalog` = 'private'
    # 这里使用的是rails的joins方法而不是find_by_sql，因为后者得到的对象是Array不能进行分页
    # 以上注释已过期
    case query_type
    when 'A','a','1'
      # @result = SysMsg.where(:msg_catalog => "private").joins(" inner join ( " + User.joins("inner join users U2 on U2.city = users.city").where('U2.id' => user_id).to_sql + " ) T on user_id = T.id")
      @result = User.find(user_id).sys_msgs.where(:msg_catalog => Const::SysMsg::CATALOG[:private],:status => Const::SysMsg::STATUS[:created])
    when 'B','b','2'
      @result = User.find(user_id).sys_msgs.where(:msg_catalog => Const::SysMsg::CATALOG[:system])
    when 'C','c','3'
      @result = SysMsg.where(:msg_catalog => Const::SysMsg::CATALOG[:public])
    when 'ALL',"all",'0'
      part1 = User.find(user_id).sys_msgs.where(:msg_catalog => Const::SysMsg::CATALOG[:private])
      part2 = User.find(user_id).sys_msgs.where(:msg_catalog => Const::SysMsg::CATALOG[:system])
      part3 = SysMsg.where(:msg_catalog => Const::SysMsg::CATALOG[:public])
      @result = SysMsg.where(:id => (part1 + part2 + part3).map{|x| x.id})
    else
      return render json: {status: :failed,reason: :parameters_error}
    end
    @result = @result.order("created_at DESC").page(params[:page]).per(10)
    
    @sys_msgs = []
    #返回推送消息的id
    @u = User.find(user_id)
    @result.each do |r|
      s = r.attributes.clone
      smt = SysMsgsTimeline.where("sys_msg_id = ? and user_id = ? ", s["id"], user_id).first
      if smt.blank?
        s["smt_id"]=""
        
      else
        s["smt_id"]=smt.id
      end

      good = Good.find(s["serv_id"])
      if good.blank?
        s["serv_catagory"]=""
        s["catalog"]=""
        s["serv_detail"]=""
      else
        s["serv_catagory"]=good.serv_catagory
        s["catalog"]=good.catalog
        s["serv_detail"]=good.serv_detail
      end
      request_u = User.find(s["user_id"])
      s["avatar"] = request_u.avatar
      s["created_at"] = s["created_at"].strftime('%Y-%m-%d %H:%M:%S')
      if(smt.status == Const::SysMsg::STATUS[:created] && good.user_id != user_id.to_i)
        @sys_msgs.push(s)
      end
    end    
    respond_to do |format|
      format.any{
          render json: {status: :success, page: @result.current_page,total_pages: @result.total_pages, feeds: @sys_msgs}
      }
    end
  end

  private
    def find_user_without_expection(user_id)
      begin
        user = User.find(user_id)
      rescue
        user =nil
      end
      return user
    end

end

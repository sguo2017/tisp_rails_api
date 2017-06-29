class Api::SysMsgsTimelines::SysMsgsTimelinesController < ApplicationController

  respond_to :json
  before_action :authenticate_user_from_token!
  before_action :set_sys_msgs_timeline, only: [:show, :edit, :update, :destroy]

  # GET /sys_msgs_timelines
  # GET /sys_msgs_timelines.json
  def index
    @sys_msgs_timelines = SysMsgsTimeline.order("created_at DESC").page(params[:page]).per(10)
    respond_to do |format|
      format.json {
        render json: {page: @sys_msgs_timelines.current_page,total_pages: @sys_msgs_timelines.total_pages, feeds: @sys_msgs_timelines}
      }
    end
  end

  # GET /sys_msgs_timelines/1
  # GET /sys_msgs_timelines/1.json
  def show
    respond_to do |format|
        format.json { render json:{location: @sys_msgs_timeline }}
    end
  end

  # GET /sys_msgs_timelines/new
  def new
    @sys_msgs_timeline = SysMsgsTimeline.new
  end

  # GET /sys_msgs_timelines/1/edit
  def edit
  end

  # POST /sys_msgs_timelines
  # POST /sys_msgs_timelines.json
  def create
    @sys_msgs_timeline = SysMsgsTimeline.new(sys_msgs_timeline_params)

    respond_to do |format|
      if @sys_msgs_timeline.save
        format.json { render json:{status: :created, location: @sys_msgs_timeline }}
      else
        format.json { render json: @sys_msgs_timeline.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /sys_msgs_timelines/1
  # PATCH/PUT /sys_msgs_timelines/1.json
  def update
    token = params[:token].presence
    user = token && User.find_by_authentication_token(token.to_s)
    respond_to do |format|
      avaliable = avaliable_orders_to_add(user)
      if  avaliable < 1
        format.json {
           render json: {status: -2, msg:"您今天创建订单数量已达上限！"}
        }
      elsif @sys_msgs_timeline.update(sys_msgs_timeline_params)
         if @sys_msgs_timeline.status == Const::SysMsg::STATUS[:finished]
            @SysMsg = SysMsg.find(@sys_msgs_timeline.sys_msg_id)
            @order = Order.new()
            token = params[:token].presence
            user = token && User.find_by_authentication_token(token.to_s)


            #需求的订单数量达到上限后不再向其它用户推送
            good = Good.find(@SysMsg.serv_id)
            @sys_msgs_timelines = SysMsgsTimeline.where("sys_msg_id = ?", @sys_msgs_timeline.sys_msg_id)
            if good.order_cnt >=  Const::REQUEST_ORDERS_LIMIT
               @sys_msgs_timelines.each do |t|
                t.status = Const::SysMsg::STATUS[:discarded]
                t.save
               end
               logger.debug("需求订单数达到上限，停止接单了")
               format.json { render json:{status: -1, msg: "需求订单数达到上限，停止接单了"} }
            else
                @order.serv_offer_id = @SysMsg.serv_id
                @order.request_user_id = @SysMsg.user_id
                @order.serv_offer_title = @SysMsg.action_desc
                @order.lately_chat_content = params[:lately_chat_content].presence        
                @order.offer_user_id = user.id
                @order.status = '00A'
                @order.connect_time = Time.new
                @order.save

                good.order_cnt = good.order_cnt + 1
                good.save

                format.json { render json:{status: 0, location: @sys_msgs_timeline, id:@order.id, avaliable: avaliable-1}}
            end 
            
         end 
        if @sys_msgs_timeline.status == Const::SysMsg::STATUS[:discarded]
            format.json { render json:{status: :ok, location: @sys_msgs_timeline}}
        end       
      else
        format.json { render json: @sys_msgs_timeline.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sys_msgs_timelines/1
  # DELETE /sys_msgs_timelines/1.json
  def destroy
    @sys_msgs_timeline.destroy
    respond_to do |format|
      format.json { head :no_content }
    end
  end

  def avaliable_orders_to_add(user)
    has_added = Order.where("created_at >= ? and (offer_user_id=?)", Time.now.beginning_of_day, user.id).size    
    limit = 0
    limit = 10 if user.level == 1
    limit = 20 if user.level == 2
    limit = 30 if user.level == 3
    limit = has_added + 1 if user.admin #管理员无限制
    avaliable = limit - has_added
    return avaliable
  end  

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_sys_msgs_timeline
      @sys_msgs_timeline = SysMsgsTimeline.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def sys_msgs_timeline_params
      params.require(:sys_msgs_timeline).permit(:user_id, :sys_msg_id, :status)
    end
end

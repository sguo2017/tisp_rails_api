class SysMsgsTimelinesController < ApplicationController

  before_action :authenticate_user!
  load_and_authorize_resource
  before_action :set_sys_msgs_timeline, only: [:show, :edit, :update, :destroy]
  before_action :config_select, only: [:new, :edit]

  # GET /sys_msgs_timelines
  # GET /sys_msgs_timelines.json
  def index
    @sys_msgs_timelines = SysMsgsTimeline.order("created_at DESC").page(params[:page]).per(10)
  end

  # GET /sys_msgs_timelines/1
  # GET /sys_msgs_timelines/1.json
  def show
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
        format.html { redirect_to @sys_msgs_timeline, notice: '用户-系统消息成功创建' }
        format.json { render :show, status: :created, location: @sys_msgs_timeline }
      else
        format.html { render :new }
        format.json { render json: @sys_msgs_timeline.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /sys_msgs_timelines/1
  # PATCH/PUT /sys_msgs_timelines/1.json
  def update
    respond_to do |format|
      if @sys_msgs_timeline.update(sys_msgs_timeline_params)
        format.html { redirect_to @sys_msgs_timeline, notice: '用户-系统消息成功更新' }
        format.json { render :show, status: :ok, location: @sys_msgs_timeline }
      else
        format.html { render :edit }
        format.json { render json: @sys_msgs_timeline.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sys_msgs_timelines/1
  # DELETE /sys_msgs_timelines/1.json
  def destroy
    @sys_msgs_timeline.destroy
    respond_to do |format|
      format.html { redirect_to sys_msgs_timelines_url, notice: '用户-系统消息成功删除' }
      format.json { head :no_content }
    end
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

    def config_select
      @status_list = Const::SysMsg::STATUS.values.map { |v| [v, v] }
      @status_list = @status_list.map { |e| [Const::SysMsg::STATUS_TRANSLATE[e[0].to_sym],e[1]] } if Const::SysMsg::STATUS_TRANSLATE
      @status_selected = @status_list[0]
    end
end

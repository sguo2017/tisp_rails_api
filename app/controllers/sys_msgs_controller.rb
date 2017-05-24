class SysMsgsController < ApplicationController
  before_action :set_sys_msg, only: [:show, :edit, :update, :destroy]

  before_filter :authenticate_user!

  before_action :set_sys_msgs_search

  before_action :config_select, only: [:edit, :new]

  # GET /sys_msgs
  # GET /sys_msgs.json
  def index
    @sys_msgs = SysMsg.order("created_at DESC").page(params[:page]).per(10)
  end

  # GET /sys_msgs/1
  # GET /sys_msgs/1.json
  def show
  end

  # GET /sys_msgs/new
  def new
    @sys_msg = SysMsg.new
  end

  # GET /sys_msgs/1/edit
  def edit
  end

  # POST /sys_msgs
  # POST /sys_msgs.json
  def create
    @sys_msg = SysMsg.new(sys_msg_params)
    set_accept_users
    respond_to do |format|
      if @sys_msg.save
        format.html { redirect_to @sys_msg, notice: '成功创建系统消息！' }
        format.json { render :show, status: :created, location: @sys_msg }
      else
        format.html { render :new }
        format.json { render json: @sys_msg.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /sys_msgs/1
  # PATCH/PUT /sys_msgs/1.json
  def update
    respond_to do |format|
      if @sys_msg.update(sys_msg_params)
        format.html { redirect_to @sys_msg, notice: '成功更新系统消息！' }
        format.json { render :show, status: :ok, location: @sys_msg }
      else
        format.html { render :edit }
        format.json { render json: @sys_msg.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sys_msgs/1
  # DELETE /sys_msgs/1.json
  def destroy
    @sys_msg.destroy
    respond_to do |format|
      format.html { redirect_to sys_msgs_url, notice: '成功删除系统消息！' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_sys_msg
      @sys_msg = SysMsg.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def sys_msg_params
      params.require(:sys_msg).permit(:user_name, :action_title, :action_desc, :user_id, :msg_catalog, :accept_users_type, :status)
    end

	  def set_sys_msgs_search
	    if !@sys_msgs_search
        @sys_msgs_search=SysMsgsSearch.new
      end
	  end

    def config_select
      @catalog_list = Const::SysMsg::CATALOG.values.map { |v| [v, v] }
      @catalog_list = @catalog_list.map { |e| [Const::SysMsg::CATALOG_TRANSLATE[e[0].to_sym],e[1]] } if Const::SysMsg::CATALOG_TRANSLATE
      @catalog_selected = @catalog_list[1]

      @status_list = Const::SysMsg::STATUS.values.map { |v| [v, v] }
      @status_list = @status_list.map { |e| [Const::SysMsg::STATUS_TRANSLATE[e[0].to_sym],e[1]] } if Const::SysMsg::STATUS_TRANSLATE
      @status_selected = @status_list[0]

      @accept_users_type_list = Const::SysMsg::ACCEPT_USERS_TYPE.values.map { |v| [v, v] }
      @accept_users_type_list = @accept_users_type_list.map { |e| [Const::SysMsg::ACCEPT_USERS_TYPE_TRANSLATE[e[0].to_sym],e[1]] } if Const::SysMsg::ACCEPT_USERS_TYPE_TRANSLATE
      @accept_users_type_list_selected = []

    end

    def set_accept_users
      cities_param = params[:sys_msg][:accept_cities]
      cities = cities_param.split(',') if cities_param.present?
      users_param = params[:sys_msg][:accept_users]
      users = users_param.split(',')
      params_hash = {
        :cities => cities,
        :users => users
      }
      @sys_msg.set_accept_users(params_hash)
    end
end

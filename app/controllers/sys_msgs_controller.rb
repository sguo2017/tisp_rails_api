class SysMsgsController < ApplicationController
  before_action :set_sys_msg, only: [:show, :edit, :update, :destroy]

  before_filter :authenticate_user!

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

    respond_to do |format|
      if @sys_msg.save
        format.html { redirect_to @sys_msg, notice: 'Sys msg was successfully created.' }
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
        format.html { redirect_to @sys_msg, notice: 'Sys msg was successfully updated.' }
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
      format.html { redirect_to sys_msgs_url, notice: 'Sys msg was successfully destroyed.' }
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
      params.require(:sys_msg).permit(:user_name, :action_title, :action_desc, :user_id)
    end
end

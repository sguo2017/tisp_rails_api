class Api::Sys::SysMsgsController < ApplicationController
  respond_to :json

  before_action :authenticate_user_from_token!

  before_action :set_sys_msg, only: [:show, :edit, :update, :destroy]



  # GET /sys_msgs
  # GET /sys_msgs.json
  def index
    token = params[:token].presence
    user = token && User.find_by_authentication_token(token.to_s)
    @sys_msgs = SysMsg.all.order("created_at desc").page(params[:page]).per(7)
    @msgs = []
    @sys_msgs.each do |msg|
         set_interval(msg)
         m = msg.attributes.clone
         begin
             s = Good.find(msg.serv_id)
             m["serv_offer"] = s
             f = Favorite.where("user_id = ? and obj_id = ? and obj_type = ?", user.id, s.id, "serv_offer").first
             #是否收藏
		         if f.blank?
		           m["isFavorited"] = false
		         else
		           m["isFavorited"] = true
		           m["favorite_id"] = f["id"].to_s
		         end
         rescue ActiveRecord::RecordNotFound => e

         end

         u = User.find(msg.user_id)
         u.authentication_token = "***"
         m["user"]=u

         @msgs.push(m)
         #logger.debug "m:#{m}"
    end

    logger.debug "msgs:#{@msgs.to_json}"

    respond_to do |format|
      format.json {
        render json: {page: @sys_msgs.current_page,total_pages: @sys_msgs.total_pages, feeds: @msgs.to_json}
      }
    end

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
    set_interval(@sys_msg)

    respond_to do |format|
      if @sys_msg.save
        format.json { render :show, status: :created, location: @sys_msg }
      else
        format.json { render json: @sys_msg.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /sys_msgs/1
  # PATCH/PUT /sys_msgs/1.json
  def update
    respond_to do |format|
      if @sys_msg.update(sys_msg_params)
        format.json { render :show, status: :ok, location: @sys_msg }
      else
        format.json { render json: @sys_msg.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sys_msgs/1
  # DELETE /sys_msgs/1.json
  def destroy
    @sys_msg.destroy
    respond_to do |format|
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
      params.require(:sys_msg).permit(:user_name, :action_title, :action_desc, :user_id, :msg_catalog, :accept_users_type, :accept_users, :status)
    end

    def set_interval(instance)
      return if instance.blank?
      interval = Time.now - instance.created_at
      if(interval/1.day) >= 1
        interval = (interval/1.day).ceil.to_s + "d"
      else
        interval = (interval/1.hour).ceil.to_s + "h"
      end
      instance.update_attributes(:interval => interval)
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

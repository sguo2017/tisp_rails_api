class Api::Villages::VillagesController < ApplicationController
  before_action :authenticate_user_from_token!
	before_action :set_village, only: [:show, :edit, :update, :destroy]

  # GET /villages
  # GET /villages.json
  #场景1： qry_type = 1，查找所有社区
  #场景2： qry_type = 2，查找用户加入的社区
  def index
    token = params[:token].presence
    user = token && User.find_by_authentication_token(token.to_s) 
    qry_type = params[:qry_type].presence
    extra_parm_s = params[:exploreparams] 
    extra_parm_h = JSON.parse extra_parm_s
    title = extra_parm_h['title']
    @villages
    if qry_type == "1"
      if title!=''
        @villages = Village.where("status = ? and name like ?", "00A","%#{title}%").order("created_at DESC").page(params[:page]).per(15)
      else
        @villages = Village.where("status = ?", "00A").first(15)
      end
    elsif qry_type =="2"
      @villages = user.villages
    end
    @villages_arr =[]
    @villages.each do |village|
      v = village.attributes.clone
      if village.users.exists?(user.id)
        v["in_village"] = true
      else
        v["in_village"] = false
      end
      v["users_count"] = village.users.size
      @villages_arr.push(v)
    end
    respond_to do |format|
      format.json {
        render json: {feeds: @villages_arr}
      }
    end
  end

  # GET /villages/1
  # GET /villages/1.json
  #查看社区详情，社区用户推荐的用户
  def show
    @users_arr = []
    @users = @village.users.order("created_at DESC").page(params[:page]).per(5) 
    @users.each do |user|
      @comments = user.comments
      @comments.each do |comment|
         u = User.find(comment.obj_id)
         good = u.goods.first
         c = u.attributes.clone
         if good
            c["goods_catalog"] = good.catalog  
         end
         @users_arr.push(c)
      end 
    end
    respond_to do |format|
      format.json {
        render json: {feeds: @users_arr}
      }
    end
  end

  # GET /villages/new
  def new
    @village = Village.new
  end

  # GET /villages/1/edit
  def edit
  end

  # POST /villages
  # POST /villages.json
  def create
    @village = Village.new(village_params)

    respond_to do |format|
      if @village.save
        format.html { redirect_to @village, notice: 'Village was successfully created.' }
        format.json { render :show, status: :created, location: @village }
      else
        format.html { render :new }
        format.json { render json: @village.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /villages/1
  # PATCH/PUT /villages/1.json
  def update
    respond_to do |format|
      if @village.update(village_params)
        format.html { redirect_to @village, notice: 'Village was successfully updated.' }
        format.json { render :show, status: :ok, location: @village }
      else
        format.html { render :edit }
        format.json { render json: @village.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /villages/1
  # DELETE /villages/1.json
  def destroy
    @village.destroy
    respond_to do |format|
      format.html { redirect_to villages_url, notice: 'Village was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def nearby_village
    token = params[:token].presence
    user = token && User.find_by_authentication_token(token.to_s) 
    @user_latitude = user.latitude
    @user_longitude = user.longitude
    @village_array = [] 
    r = 6371.0000;    #地球半径千米  
    dis = 5.0000 * 2 * 10;   #0.5千米距离  
    dlng =  2*Math.asin(Math.sin(dis/(2*r))/Math.cos(@user_latitude.to_f*3.14/180)).round(4) ;  
    dlng = dlng*180/3.14.round(4);#角度转为弧度  
    dlat = dis/r.round(4);  
    dlat = dlat*180/3.14.round(4);    
    minlat = @user_latitude.to_f - dlat;  
    maxlat = @user_latitude.to_f + dlat;  
    minlng = @user_longitude.to_f - dlng;  
    maxlng = @user_longitude.to_f + dlng;  

    @villages  = Village.where("latitude >= ? and latitude <= ? and longitude >= ? and longitude <= ? ", minlat, maxlat, minlng, maxlng)  
    @villages.each_with_index do |village|
      v = village.attributes.clone
      if village.latitude.blank? || village.longitude.blank?

      else
        @village_array.push(v)
      end
    end  

    respond_to do |format|
      format.json {
          render json: {status: 0, feeds: @village_array}
        }
    end
  end

  def add_user
      user_id = params[:user_id].presence
      village_id = params[:village_id].presence
      @user = User.find(user_id)
      if @user.villages.length <6
        @village = Village.find(village_id)
        @village.users << @user
        respond_to do |format|
          format.json {
              render json: {status: 0,  msg: '加入成功'}
            }
        end
      else
        respond_to do |format|
          format.json {
              render json: {status: -1, msg: '加入的社区不能超过6个'}
            }
        end
      end
      
  end

  def delete_user
      user_id = params[:user_id].presence
      village_id = params[:village_id].presence
      @user = User.find(user_id)
      @village = Village.find(village_id)
      @village.users.delete(@user)
      respond_to do |format|
        format.json {
            render json: {status: 0}
          }
      end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_village
      @village = Village.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def village_params
      params.require(:village).permit(:name)
    end
    def village_user_params
      params.permit(:user_id, :village_id)
    end
end

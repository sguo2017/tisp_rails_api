class Api::Users::UsersBehaviorsController < ApplicationController
 respond_to :json
 before_action :set_users_behavior, only: [:show, :update, :destroy]

  # GET /users_behaviors
  # GET /users_behaviors.json
  def index
    @users_behaviors = UsersBehavior.all
  end

  # GET /users_behaviors/1
  # GET /users_behaviors/1.json
  def show
  end

  # POST /users_behaviors
  # POST /users_behaviors.json
  def create
    @users_behavior = UsersBehavior.new(users_behavior_params)

    respond_to do |format|
      if @users_behavior.save
        format.js { render json:{sattus:1, id:@users_behavior.id}}
        format.json { render json:{sattus:1, id:@users_behavior.id}}
      else
        format.js { render json:{sattus:-1}}
        format.json { render json:{sattus:-1}}
      end
    end
  end

  # PATCH/PUT /users_behaviors/1
  # PATCH/PUT /users_behaviors/1.json
  def update
    respond_to do |format|
      if @users_behavior.update(users_behavior_params)
        format.js { render json:{sattus:1, id:@users_behavior.id}}
        format.json { render json:{sattus:1, id:@users_behavior.id}}
      else
        format.js { render json:{sattus:-1}}
        format.json { render json:{sattus:-1}}
      end
    end
  end

  # DELETE /users_behaviors/1
  # DELETE /users_behaviors/1.json
  def destroy
    @users_behavior.destroy
    respond_to do |format|
      format.js { render json:{sattus:1, id:@users_behavior.id}}
      format.json { render json:{sattus:1, id:@users_behavior.id}}
    end
  end

  def client_ip
    render json: {ip:request.remote_ip}
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_users_behavior
      @users_behavior = UsersBehavior.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def users_behavior_params
      params.require(:users_behavior).permit(:user_id, :from_url, :request_url, :os, :broswer, :ip, :geo_position, :click_positions, :requested_at, :left_at)
    end
end

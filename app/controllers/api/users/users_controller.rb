class Api::Users::UsersController < ApplicationController
	respond_to :json

  # before_action :authenticate_user_from_token!
  before_action :set_user, only: [ :update]
  # GET /users/1
  # GET /users/1.json
  def show
  	@user = User.find(params[:id])
  	respond_to do |format|
  		if @user
  			format.json {
         	render json: {status:0, user: @user.to_json}
        }
      else
      	format.json {
         	render json: {status:0, user: @user.to_json}
        }
  		end
  		
  	end
  end

  def update
    respond_to do |format|
      if @user.update(user_params)
        format.json {
          render json: {status: 0 ,msg: "success"}
        }
      else
        format.json {
          render json: {status: -1 ,msg: "failed"}
        }
      end
    end
  end

  private 
    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:id, :status, :email, :password, :name)
    end
end

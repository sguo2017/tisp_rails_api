class Api::Users::UsersController < ApplicationController
	respond_to :json

  before_action :authenticate_user_from_token!

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

  private 
    def user_params
      params.require(:user).permit(:id)
    end
end

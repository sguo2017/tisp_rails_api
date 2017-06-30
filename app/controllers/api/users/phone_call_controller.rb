class Api::Users::PhoneCallController < ApplicationController
	respond_to :json

  before_action :authenticate_user_from_token!

  def update
   respond_to do |format|
      @user = User.find(params[:id])
      # params[:user][:name] = @user.name + ""
      switch_to = false
      if user_params[:switch_to] == 1 
				switch_to = true
      end
      User.where(id: params[:id].to_i).update_all(switch_to: switch_to, call_from: user_params[:call_from], call_to: user_params[:call_to])
      format.json {
         render json: {status:0, msg:"success"}
      }
      # if @user.update(user_params)
      #   format.json {
      #      render json: {status:0, msg:"success"}
      #   }
      # else
      #   format.json {
      #      render json: {status:-1, msg:"fail"}
      #   }
      # end
    end
  end

  private 
    def user_params
      params.require(:user).permit(:name, :switch_to, :call_from, :call_to)
    end
end

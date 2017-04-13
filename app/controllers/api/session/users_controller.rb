class Api::Session::UsersController < ApplicationController

  respond_to :json

  before_filter :authenticate_user_from_token!

  before_action :set_user, only: [:show,:edit,:update]

  # GET /user/1
  # GET /user/1.json
  def show
  end

  # GET /user/1/edit
  def edit
  end

  # PATCH/PUT /user/1
  # PATCH/PUT /user/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.json { render json:{"updated":"true"}}
      else
        format.json { render json:{"updated":"false"}}
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:avatar, :user_id)
    end

end

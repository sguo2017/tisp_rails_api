class Api::Users::SessionsController < ApplicationController

	#POST /api/users/sessions/
	def create
		@user = User.find_for_database_authentication(:email => params[:user][:email])
		return render json: {error: {status:-1}} unless @user
		respond_to do |format|
		  if @user.valid_password?(params[:user][:password])
		    sign_in("user", @user)
			set_geo_infos
			logger.debug "user info: #{@user.to_json}"
			format.json {
			  render json: {token:@user.authentication_token, user: @user.to_json}
			}
			format.js {
			  render json: {token:@user.authentication_token, user: @user.to_json}
			}
		  else
			format.json {
			  render json: {error: {status:-1}}
			}
		  end
		end
	end

	#POST /api/users/sms_login/
  #
	def sms_login
    sms_code = params[:user][:code].presence
    num = params[:user][:num].presence
    sms = SmsSend.where("TIMESTAMPDIFF(MINUTE,created_at ,now())<#{Const::SMS_TIME_LIMIT} and sms_type='code' and send_content=? and recv_num =?", sms_code, num).first
    return render json: {error: {status:-1}} unless sms
    user_id = sms.user_id
    @user = User.find(user_id)
    return render json: {error: {status:-1}} unless @user
    respond_to do |format|
        sign_in("user", @user)
        set_geo_infos
        if !@current_user
           @current_user = @user
           Thread.current[:tispr_user] = @user
           session[:current_tispr_user] = @user
        end
        if @user.avatar
            session[:user_avatar]=@user.avatar
        end

        format.json {
          render json: {token:@user.authentication_token, user: @user.to_json}
        }
    end
  end

  #POST /api/users/token_login/
	def token_login
		token = params[:token].presence
		return render json: {error: {status:-1}} unless token
		@user = User.where("TIMESTAMPDIFF(DAY,updated_at ,now())<#{Const::TOKEN_TIME_LIMIT} and authentication_token=?", token.to_s).first
		return render json: {error: {status:-1}} unless @user
		logger.debug "user info: #{@user.to_json}"
		respond_to do |format|
			sign_in("user", @user)
			set_geo_infos
			if !@current_user
				@current_user = @user
				Thread.current[:tispr_user] = @user
				session[:current_tispr_user] = @user
			end
			if @user.avatar
				session[:user_avatar]=@user.avatar
			end

        format.json {
          render json: {token:@user.authentication_token, user: @user.to_json}
        }
		end
	end

	#DELETE /api/users/sessions/:id/
	#注销，这里进行更换token操作，使token失效
	def destroy
		@user=User.find(params[:id])
		@user.ensure_authentication_token
		logger.debug "user_id:#{@user.id}### logined out! token changed!"
		respond_to do |format|
		  format.json { render json:{msg: "logined out"}}
		  format.js {render json: {msg: "logined out"}}
		end
		@user = nil
	end

	private
	  def set_geo_infos
	    geo_params = params.require(:user).permit(:district, :city, :province, :country, :latitude, :longitude)
        @user.update(geo_params)
	  end


end

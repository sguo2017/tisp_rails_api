class Api::Users::SessionsController < ApplicationController

	#POST /api/users/sessions/
	#
	#功能：1 登录功能；2 修改密码首先要验证密码；
	#
	def create
		@user = User.find_for_database_authentication(:email => params[:user][:email])
		@check_password = params[:check_password]
		return render json: {error: {status:-1}} unless @user
		respond_to do |format|
		  if @user.valid_password?(params[:user][:password])
		  	#判断是登录还是验证密码的过程
		  	if @check_password.blank?
		  		sign_in("user", @user)
					set_geo_infos
					format.json {
					  render json: {token:@user.authentication_token, user: @user.to_json}
					}
					format.js {
					  render json: {token:@user.authentication_token, user: @user.to_json}
					}
				else				
					format.json {
					  render json: {status:'OK'}
					}
		  	end	    
		  else
				format.json {
				  render json: {error: {status:-1}}
				}
		  end
		end
	end

	#POST /api/users/sms_login/
    #change_phone参数判断是更换手机号还是通过手机号登录
	def sms_login
    sms_code = params[:user][:code].presence
    num = params[:user][:num].presence
    sms = SmsSend.where("TIMESTAMPDIFF(MINUTE,created_at ,now())<#{Const::SMS_TIME_LIMIT} and sms_type='code' and send_content=? and recv_num =?", sms_code, num).first
    @change_phone = params[:change_phone]
    return render json: {error: {status:-1}} unless sms
    user_id = sms.user_id
    @user = User.find(user_id)
    return render json: {error: {status:-1}} unless @user
    respond_to do |format|	
    	if @change_phone.blank?    	
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
			else
				@user.num = num 
				if @user.save
					format.json {
					  render json: {status:'OK'}
					}	
				end			
			end
    end	    
  end

  #POST /api/users/phone_login/
  #手机号码登录
  def phone_login
		@user = User.find_for_database_authentication(:num => params[:user][:num])
		@check_password = params[:check_password]
		return render json: {error: {status:-1}} unless @user
		respond_to do |format|
		  if @user.valid_password?(params[:user][:password])
		  	#判断是登录还是验证密码的过程
		  	if @check_password.blank?
		  		sign_in("user", @user)
				set_geo_infos
				format.json {
				  render json: {token:@user.authentication_token, user: @user.to_json}
				}
				format.js {
				  render json: {token:@user.authentication_token, user: @user.to_json}
				}
			else				
				format.json {
				  render json: {status:'OK'}
				}
		  	end	    
		  else
				format.json {
				  render json: {error: {status:-1}}
				}
		  end
		end 
  end  

  #POST /api/users/token_login/
	def token_login
		token = params[:token].presence
		
		@user = User.where("TIMESTAMPDIFF(DAY,updated_at ,now())<#{Const::TOKEN_TIME_LIMIT} and authentication_token=?", token.to_s).first
		
		if @user.blank?
			respond_to do |format|
			  format.json {
			  	render json: {status: Const::ERROR_TYPE[:user_is_nil].to_s}
			  }
			end
		else 
			# @user = User.find(@user.id)
	
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
	        render json: {token: @user.authentication_token, user: @user.to_json}
	      }
			end

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
	    geo_params = params.require(:user).permit(:district, :city, :province, :country, :latitude, :longitude, :website)
        @user.update(geo_params)
	  end
end

class Api::Users::SessionsController < ApplicationController

	#POST /api/users/sessions/
	def create
		user = User.find_for_database_authentication(:email => params[:user][:email])
		return render json: {error: {status:-1}} unless user
		respond_to do |format|
		  if user.valid_password?(params[:user][:password])
			logger.debug "user info: #{user.to_json}"        
			format.json { 
			  render json: {token:user.authentication_token, user: user.to_json}
			}
			format.js {
			  render json: {token:user.authentication_token, user: user.to_json}
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
    sms = SmsSend.find_by_send_content(sms_code)
    return render json: {error: {status:-1}} unless sms    
    user_id = sms.user_id    
    num = params[:user][:num].presence  
    user = User.find(user_id)
    return render json: {error: {status:-1}} unless user
    respond_to do |format|
      if num == user.num
        sign_in("user", user)        
        if !@current_user 
           @current_user = user
           Thread.current[:tispr_user] = user
           session[:current_tispr_user] = user
        end
        if user.avatar
            session[:user_avatar]=user.avatar
        end   

        logger.debug "user info: #{user.to_json}"        
        format.json { 
          render json: {token:user.authentication_token, user: user.to_json}
        }
        format.js {
          #render :js => "alert('hello')"    
          redirect_to "/"   
        }
      else
        format.json {
          render json: {error: {status:-1}}
        }
      end
    end
  end

	#DELETE /api/users/sessions/:id/
	#注销，这里进行更换token操作，使token失效
	def destroy
		user=User.find(params[:id])
		user.ensure_authentication_token
		logger.debug "user_id:#{user.id}### logined out! token changed!"
		respond_to do |format|
		  format.json { render json:{msg: "logined out"}}
		  format.js {render json: {msg: "logined out"}}
		end
	end

end
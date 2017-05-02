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
class Api::Users::InvitationCodeController < ApplicationController
	respond_to :json

	before_action :authenticate_user_from_token!,only: [:index]

	def index
		token = params[:token].presence
    user = token && User.find_by_authentication_token(token.to_s)
    @invitation = Invitation.find_by_user_id(user.id)
    if @invitation.blank?
    	@invitation = Invitation.create!(user_id:user.id, code: FFaker::IdentificationMX.rfc_persona_fisica)
    end
		respond_to do |format|
			format.json {
         render json: { status: 0, code: @invitation.code}
      }
		end
	end
  #版本V2
	def validate_code
		@code = params[:code]
		@invitation = Invitation.find_by_code(@code)
		if @invitation.blank?
			return render json: {error: {status:-2 ,msg: "邀请码不存在"}}
		elsif @invitation.status != '00A'
			return render json: {error: {status:-1 ,msg: "邀请码已失效"}}
		else
			respond_to do |format|
				format.json {
           render json: {status:0, msg: "邀请码验证通过"}
        }
			end
		end
	end

	 private

    # Never trust parameters from the scary internet, only allow the white list through.
    def invitation_params
      params.permit(:code)
    end
end

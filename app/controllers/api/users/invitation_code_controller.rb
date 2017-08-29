class Api::Users::InvitationCodeController < ApplicationController
	respond_to :json

	def create
		
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
           render json: {status:0}
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

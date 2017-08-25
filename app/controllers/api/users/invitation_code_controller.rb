class Api::Users::InvitationCodeController < ApplicationController
	respond_to :json

	def create
		
	end

	def validate_code
		@code = params[:code]
		@invitation = Invitation.find_by_code(@code)
		if @invitation.blank?
			respond_to do |format|
				format.json {
           render json: {status:-2}
        }
			end
		elsif @invitation.status != '00A'
			respond_to do |format|
				format.json {
           render json: {status:-1}
        }
			end
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

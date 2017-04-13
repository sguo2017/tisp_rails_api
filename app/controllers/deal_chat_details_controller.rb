class DealChatDetailsController < ApplicationController
  before_action :set_deal_chat_detail, only: [:show, :edit, :update, :destroy]

  # GET /deal_chat_details
  # GET /deal_chat_details.json
  def index
    @deal_chat_details = DealChatDetail.page(params[:page]).per(5)
  end

  # GET /deal_chat_details/1
  # GET /deal_chat_details/1.json
  def show
  end

  # GET /deal_chat_details/new
  def new
    @deal_chat_detail = DealChatDetail.new
  end

  # GET /deal_chat_details/1/edit
  def edit
  end

  # POST /deal_chat_details
  # POST /deal_chat_details.json
  def create
    @deal_chat_detail = DealChatDetail.new(deal_chat_detail_params)

    respond_to do |format|
      if @deal_chat_detail.save
        format.html { redirect_to @deal_chat_detail, notice: 'Deal chat detail was successfully created.' }
        format.json { render :show, status: :created, location: @deal_chat_detail }
      else
        format.html { render :new }
        format.json { render json: @deal_chat_detail.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /deal_chat_details/1
  # PATCH/PUT /deal_chat_details/1.json
  def update
    respond_to do |format|
      if @deal_chat_detail.update(deal_chat_detail_params)
        format.html { redirect_to @deal_chat_detail, notice: 'Deal chat detail was successfully updated.' }
        format.json { render :show, status: :ok, location: @deal_chat_detail }
      else
        format.html { render :edit }
        format.json { render json: @deal_chat_detail.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /deal_chat_details/1
  # DELETE /deal_chat_details/1.json
  def destroy
    @deal_chat_detail.destroy
    respond_to do |format|
      format.html { redirect_to deal_chat_details_url, notice: 'Deal chat detail was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_deal_chat_detail
      @deal_chat_detail = DealChatDetail.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def deal_chat_detail_params
      params.require(:deal_chat_detail).permit(:deal_id, :chat_content, :user_id, :catalog)
    end
end

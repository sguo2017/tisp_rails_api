class SmsSendsController < ApplicationController
  before_action :set_sms_send, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource
  before_action :set_sms_sends_search

  # GET /sms_sends
  # GET /sms_sends.json
  def index
    @sms_sends = SmsSend.order("created_at DESC").page(params[:page]).per(10)
  end

  # GET /sms_sends/1
  # GET /sms_sends/1.json
  def show
  end

  # GET /sms_sends/new
  def new
    @sms_send = SmsSend.new
  end

  # GET /sms_sends/1/edit
  def edit
  end

  # POST /sms_sends
  # POST /sms_sends.json
  def create
    @sms_send = SmsSend.new(sms_send_params)

    respond_to do |format|
      if @sms_send.save
        format.html { redirect_to @sms_send, notice: 'Sms send was successfully created.' }
        format.json { render :show, status: :created, location: @sms_send }
      else
        format.html { render :new }
        format.json { render json: @sms_send.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /sms_sends/1
  # PATCH/PUT /sms_sends/1.json
  def update
    respond_to do |format|
      if @sms_send.update(sms_send_params)
        format.html { redirect_to @sms_send, notice: 'Sms send was successfully updated.' }
        format.json { render :show, status: :ok, location: @sms_send }
      else
        format.html { render :edit }
        format.json { render json: @sms_send.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sms_sends/1
  # DELETE /sms_sends/1.json
  def destroy
    @sms_send.destroy
    respond_to do |format|
      format.html { redirect_to sms_sends_url, notice: 'Sms send was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_sms_send
      @sms_send = SmsSend.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def sms_send_params
      params.require(:sms_send).permit(:recv_num, :send_content, :state, :sms_type, :user_id)
    end
	
	def set_sms_sends_search
      if !@sms_sends_search
        @sms_sends_search=SmsSendsSearch.new
      end
    end
end

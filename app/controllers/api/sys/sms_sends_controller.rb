class Api::Sys::SmsSendsController < ApplicationController
	require 'net/http'
  
  respond_to :json

  #before_filter :authenticate_user_from_token!
  
  before_action :set_sms_send, only: [:show, :edit, :update, :destroy]

  # GET /sms_sends
  # GET /sms_sends.json
  def index
    @sms_sends = SmsSend.order("created_at DESC").page(params[:page]).per(5)
    
	  respond_to do |format|
	      format.json {
	        render json: {page: @sms_sends.current_page, total_pages: @sms_sends.total_pages, feeds: @sms_sends.to_json}
      	}
	  end        
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
    ret_status = -1
    ret_msg = "fails"
    @sms_send = SmsSend.new()
    
    recv_num = params[:recv_num].presence
    user = token && User.find_by_num(recv_num.to_s)
    if !user
      ret_msg = "此号码没有注册用户"
      render json: {status:"#{ret_status}", msg:"#{ret_msg}"}
    end
    
    @sms_send.user_id = user.id

    @sms_send.recv_num = recv_num
    
    sms_type = params[:sms_type].presence
    send_content = ""
    #code短信验证码
    if "code" == sms_type
    	send_content = rand(999999)
    else
    
    end       

    @sms_send.send_content = send_content
    
    respond_to do |format| 	
      if @sms_send.save       
      begin
      	uri = URI.parse("http://123.56.157.233:9090/FastDFSWeb/servlet/smsSendServlet?num=#{recv_num}&param=#{send_content}")
      	http = Net::HTTP.new(uri.host, uri.port)
      	request = Net::HTTP::Post.new(uri.request_uri)
        #request['Content-Type'] = 'application/json;charset=utf-8'
        #request['User-Agent'] = 'Mozilla/5.0 (Windows NT 5.1; rv:29.0) Gecko/20100101 Firefox/29.0'
        #request.body = params.to_json
        response = http.start { |http| http.request(request) }
        puts response.body.inspect
        puts JSON.parse response.body
        ret_status = 0
    		ret_msg = "success"
      rescue =>err
        #return nil
		    ret_status = -1
		    ret_msg = "fails"        
      end           
        format.json {
           render json: {status:"#{ret_status}", msg:"#{ret_msg}"}
        }
      else
       format.json {
           render json: {status:"#{ret_status}", msg:"#{ret_msg}"}
        } 
      end
     end
  end

  # PATCH/PUT /sms_sends/1
  # PATCH/PUT /sms_sends/1.json
  def update
	  	if @sms_send.update(sms_send_params)
	    		respond_to do |format|
	        	format.json {
	      	     render json: {status:0, msg:"success"}
	        	}
	        end
	    else
	    	respond_to do |format|
		       format.json {
		           render json: {status:-1, msg:"fail"}
		        }
		     end   
	    end
  end

  # DELETE /sms_sends/1
  # DELETE /sms_sends/1.json
  def destroy
    @sms_send.destroy
    respond_to do |format|
        format.json {
           render json: {status:0, msg:"success"}
        }
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
end

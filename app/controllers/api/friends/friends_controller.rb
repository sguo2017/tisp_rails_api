class Api::Friends::FriendsController < ApplicationController
	respond_to :json

	before_action :set_friend, only: [:show, :edit, :update, :destroy]

  # GET /friends
  # GET /friends.json
  def index
    @friends = Friend.where("status = ?", Const::FRIEND_STATUS[:created]).order("created_at DESC").page(params[:page]).per(5)
    respond_to do |format|
      format.json {
        render json: {page: @friends.current_page, total_pages: @friends.total_pages, feeds: @friends.to_json}
      }
    end
  end

  # GET /friends/1
  # GET /friends/1.json
  def show
  end

  # GET /friends/new
  def new
    @friend = Friend.new
  end

  # GET /friends/1/edit
  def edit
  end

  def create
    @friend = Friend.new(friend_params)
    respond_to do |format|
      if @friend.save
        format.json {
          # render json: {feeds: @new_list.to_json}
          render json: {feed: @friend}
        }
      end
    end
  end

  # POST /friends/friend_list
  def friend_list	
  	list = params[:friends].presence
  	logger.debug "好友列表#{list.to_json}"
  	@new_list = []
  	list = JSON.parse(list.to_json)
  	list.each do |friend_arg|
      friend = Friend.new(friend_arg)
  		@pre_user = User.find_by_num(friend.friend_num)
  		if @pre_user && @pre_user.status == Const::USER_STATUS[:created]
  			friend.status = Const::FRIEND_STATUS[:created]
  		elsif @pre_user && @pre_user.status == Const::USER_STATUS[:recommended]
  			friend.status = Const::FRIEND_STATUS[:recommended]
  		else
  			friend.status = Const::FRIEND_STATUS[:unjoined]
  		end
  		friend.save
  		@new_list.push(friend)
  	end

    respond_to do |format|
      format.json {
        # render json: {feeds: @new_list.to_json}
        render json: {feeds: @new_list}
      }
    end
  end

  # PATCH/PUT /friends/1
  # PATCH/PUT /friends/1.json
  def update
    respond_to do |format|
      if @friend.update(friend_params)
        format.json { render :show, status: :ok, location: @friend }
      else
        format.json { render json: @friend.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /friends/1
  # DELETE /friends/1.json
  def destroy
    @friend.status = Const::FRIEND_STATUS[:notfriend]
    if @friend.save
       respond_to do |format|
        format.json {render json: {status:0, msg:"success"}}
      end
    else
      respond_to do |format|
        format.json {render json: {status:-1, msg:"fail"}}
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_friend
      @friend = Friend.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def friend_params
      params.permit(:friend_id, :friend_name, :friend_num, :user_id, :status, { friends: [ :user_id, :friend_num, :friend_name] } )
    end
end

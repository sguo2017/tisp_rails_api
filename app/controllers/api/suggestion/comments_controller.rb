class Api::Suggestion::CommentsController < ApplicationController
  before_action :authenticate_user_from_token!
	before_action :set_comment, only: [:show, :edit, :update, :destroy]

  # GET /comments
  # GET /comments.json
  def index
    token = params[:token].presence
    user = token && User.find_by_authentication_token(token.to_s)
    user_id = params[:user_id].presence
    qry_type = params[:qry_type].presence
    #场景1：查找某用户的推荐（好评），返回推荐（好评）的用户
    if qry_type=="1"
      @comments = Comment.where("user_id=? and obj_type=? and status=?", user.id, "user", "good").order("created_at DESC").page(params[:page]).per(10)
      @users=[]
      @comments.each do |comment|
        @user=User.find(comment.obj_id)
        if @user
          @users.push(@user)
        end
      end
      respond_to do |format|
        format.json {
          render json: {page: @comments.current_page, total_pages: @comments.total_pages, feeds: @users.to_json}
        }
      end
    #场景2：查找某用户的被评价内容，返回评价
    elsif qry_type=="2"
      @comments = Comment.where("obj_id=? and obj_type=?", user_id, "user").order("created_at DESC").page(params[:page]).per(10)
      @comments_arr=[]
      @comments.each do |comment|
        c = comment.attributes.clone
        @user=User.find(comment.user_id)
        if @user
          c["user_name"] = @user.name
          c["user_avatar"] = @user.avatar
          c["created_at"] = c["created_at"].strftime('%Y-%m-%d %H:%M:%S')
        end
        @comments_arr.push(c)
      end
      respond_to do |format|
        format.json {
          render json: {page: @comments.current_page, total_pages: @comments.total_pages, feeds: @comments_arr}
        }
      end
    end
    
  end

  # GET /comments/1
  # GET /comments/1.json
  def show
  end

  # GET /comments/new
  def new
    @comment = Comment.new
  end

  # GET /comments/1/edit
  def edit
  end

  # POST /comments
  # POST /comments.json
  def create
    @comment = Comment.new(comment_params)
    respond_to do |format|
      if @comment.save
        format.json {
          render json: {status:0, msg:"success"} 
        }
      else
      	format.json { 
          render json: {status:-1, msg:"failed"} 
        }
      end
    end
  end

  # PATCH/PUT /comments/1
  # PATCH/PUT /comments/1.json
  def update
    respond_to do |format|
      if @comment.update(comment_params)
        format.html { redirect_to @comment, notice: 'Comment was successfully updated.' }
        format.json { render :show, status: :ok, location: @comment }
      else
        format.html { render :edit }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /comments/1
  # DELETE /comments/1.json
  def destroy
    @comment.destroy
    respond_to do |format|
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_comment
      @comment = Comment.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def comment_params
      params.require(:comment).permit(:obj_id, :user_id, :obj_type, :content)
    end
end

class Api::SysMsgsTimelines::SysMsgsTimelinesController < ApplicationController

  respond_to :json
  before_action :authenticate_user_from_token!
  before_action :set_sys_msgs_timeline, only: [:show, :edit, :update, :destroy]

  # GET /sys_msgs_timelines
  # GET /sys_msgs_timelines.json
  def index
    @sys_msgs_timelines = SysMsgsTimeline.order("created_at DESC").page(params[:page]).per(10)
    respond_to do |format|
      format.json {
        render json: {page: @sys_msgs_timelines.current_page,total_pages: @sys_msgs_timelines.total_pages, feeds: @sys_msgs_timelines}
      }
    end
  end

  # GET /sys_msgs_timelines/1
  # GET /sys_msgs_timelines/1.json
  def show
    respond_to do |format|
        format.json { render json:{location: @sys_msgs_timeline }}
    end
  end

  # GET /sys_msgs_timelines/new
  def new
    @sys_msgs_timeline = SysMsgsTimeline.new
  end

  # GET /sys_msgs_timelines/1/edit
  def edit
  end

  # POST /sys_msgs_timelines
  # POST /sys_msgs_timelines.json
  def create
    @sys_msgs_timeline = SysMsgsTimeline.new(sys_msgs_timeline_params)

    respond_to do |format|
      if @sys_msgs_timeline.save
        format.json { render json:{status: :created, location: @sys_msgs_timeline }}
      else
        format.json { render json: @sys_msgs_timeline.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /sys_msgs_timelines/1
  # PATCH/PUT /sys_msgs_timelines/1.json
  def update
    respond_to do |format|
      if @sys_msgs_timeline.update(sys_msgs_timeline_params)
        format.json { render json:{status: :ok, location: @sys_msgs_timeline}}
      else
        format.json { render json: @sys_msgs_timeline.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sys_msgs_timelines/1
  # DELETE /sys_msgs_timelines/1.json
  def destroy
    @sys_msgs_timeline.destroy
    respond_to do |format|
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_sys_msgs_timeline
      @sys_msgs_timeline = SysMsgsTimeline.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def sys_msgs_timeline_params
      params.require(:sys_msgs_timeline).permit(:user_id, :sys_msg_id, :status)
    end
end

require 'test_helper'

class SysMsgsTimelinesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @sys_msgs_timeline = sys_msgs_timelines(:one)
  end

  test "should get index" do
    get sys_msgs_timelines_url
    assert_response :success
  end

  test "should get new" do
    get new_sys_msgs_timeline_url
    assert_response :success
  end

  test "should create sys_msgs_timeline" do
    assert_difference('SysMsgsTimeline.count') do
      post sys_msgs_timelines_url, params: { sys_msgs_timeline: { sys_msg_id: @sys_msgs_timeline.sys_msg_id, user_id: @sys_msgs_timeline.user_id } }
    end

    assert_redirected_to sys_msgs_timeline_url(SysMsgsTimeline.last)
  end

  test "should show sys_msgs_timeline" do
    get sys_msgs_timeline_url(@sys_msgs_timeline)
    assert_response :success
  end

  test "should get edit" do
    get edit_sys_msgs_timeline_url(@sys_msgs_timeline)
    assert_response :success
  end

  test "should update sys_msgs_timeline" do
    patch sys_msgs_timeline_url(@sys_msgs_timeline), params: { sys_msgs_timeline: { sys_msg_id: @sys_msgs_timeline.sys_msg_id, user_id: @sys_msgs_timeline.user_id } }
    assert_redirected_to sys_msgs_timeline_url(@sys_msgs_timeline)
  end

  test "should destroy sys_msgs_timeline" do
    assert_difference('SysMsgsTimeline.count', -1) do
      delete sys_msgs_timeline_url(@sys_msgs_timeline)
    end

    assert_redirected_to sys_msgs_timelines_url
  end
end

require 'test_helper'

class SysMsgsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @sys_msg = sys_msgs(:one)
  end

  test "should get index" do
    get sys_msgs_url
    assert_response :success
  end

  test "should get new" do
    get new_sys_msg_url
    assert_response :success
  end

  test "should create sys_msg" do
    assert_difference('SysMsg.count') do
      post sys_msgs_url, params: { sys_msg: { action_desc: @sys_msg.action_desc, action_title: @sys_msg.action_title, user_id: @sys_msg.user_id, user_name: @sys_msg.user_name } }
    end

    assert_redirected_to sys_msg_url(SysMsg.last)
  end

  test "should show sys_msg" do
    get sys_msg_url(@sys_msg)
    assert_response :success
  end

  test "should get edit" do
    get edit_sys_msg_url(@sys_msg)
    assert_response :success
  end

  test "should update sys_msg" do
    patch sys_msg_url(@sys_msg), params: { sys_msg: { action_desc: @sys_msg.action_desc, action_title: @sys_msg.action_title, user_id: @sys_msg.user_id, user_name: @sys_msg.user_name } }
    assert_redirected_to sys_msg_url(@sys_msg)
  end

  test "should destroy sys_msg" do
    assert_difference('SysMsg.count', -1) do
      delete sys_msg_url(@sys_msg)
    end

    assert_redirected_to sys_msgs_url
  end
end

require 'test_helper'

class SmsSendsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @sms_send = sms_sends(:one)
  end

  test "should get index" do
    get sms_sends_url
    assert_response :success
  end

  test "should get new" do
    get new_sms_send_url
    assert_response :success
  end

  test "should create sms_send" do
    assert_difference('SmsSend.count') do
      post sms_sends_url, params: { sms_send: { recv_num: @sms_send.recv_num, send_content: @sms_send.send_content, sms_type: @sms_send.sms_type, state: @sms_send.state } }
    end

    assert_redirected_to sms_send_url(SmsSend.last)
  end

  test "should show sms_send" do
    get sms_send_url(@sms_send)
    assert_response :success
  end

  test "should get edit" do
    get edit_sms_send_url(@sms_send)
    assert_response :success
  end

  test "should update sms_send" do
    patch sms_send_url(@sms_send), params: { sms_send: { recv_num: @sms_send.recv_num, send_content: @sms_send.send_content, sms_type: @sms_send.sms_type, state: @sms_send.state } }
    assert_redirected_to sms_send_url(@sms_send)
  end

  test "should destroy sms_send" do
    assert_difference('SmsSend.count', -1) do
      delete sms_send_url(@sms_send)
    end

    assert_redirected_to sms_sends_url
  end
end

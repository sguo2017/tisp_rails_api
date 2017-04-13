require 'test_helper'

class DealChatsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @deal_chat = deal_chats(:one)
  end

  test "should get index" do
    get deal_chats_url
    assert_response :success
  end

  test "should get new" do
    get new_deal_chat_url
    assert_response :success
  end

  test "should create deal_chat" do
    assert_difference('DealChat.count') do
      post deal_chats_url, params: { deal_chat: { deal_id: @deal_chat.deal_id, lately_chat_content: @deal_chat.lately_chat_content, serv_offer_id: @deal_chat.serv_offer_id, serv_offer_titile: @deal_chat.serv_offer_titile, serv_offer_user_name: @deal_chat.serv_offer_user_name } }
    end

    assert_redirected_to deal_chat_url(DealChat.last)
  end

  test "should show deal_chat" do
    get deal_chat_url(@deal_chat)
    assert_response :success
  end

  test "should get edit" do
    get edit_deal_chat_url(@deal_chat)
    assert_response :success
  end

  test "should update deal_chat" do
    patch deal_chat_url(@deal_chat), params: { deal_chat: { deal_id: @deal_chat.deal_id, lately_chat_content: @deal_chat.lately_chat_content, serv_offer_id: @deal_chat.serv_offer_id, serv_offer_titile: @deal_chat.serv_offer_titile, serv_offer_user_name: @deal_chat.serv_offer_user_name } }
    assert_redirected_to deal_chat_url(@deal_chat)
  end

  test "should destroy deal_chat" do
    assert_difference('DealChat.count', -1) do
      delete deal_chat_url(@deal_chat)
    end

    assert_redirected_to deal_chats_url
  end
end

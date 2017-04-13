require 'test_helper'

class DealChatDetailsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @deal_chat_detail = deal_chat_details(:one)
  end

  test "should get index" do
    get deal_chat_details_url
    assert_response :success
  end

  test "should get new" do
    get new_deal_chat_detail_url
    assert_response :success
  end

  test "should create deal_chat_detail" do
    assert_difference('DealChatDetail.count') do
      post deal_chat_details_url, params: { deal_chat_detail: { catalog: @deal_chat_detail.catalog, chat_content: @deal_chat_detail.chat_content, deal_id: @deal_chat_detail.deal_id, user_id: @deal_chat_detail.user_id } }
    end

    assert_redirected_to deal_chat_detail_url(DealChatDetail.last)
  end

  test "should show deal_chat_detail" do
    get deal_chat_detail_url(@deal_chat_detail)
    assert_response :success
  end

  test "should get edit" do
    get edit_deal_chat_detail_url(@deal_chat_detail)
    assert_response :success
  end

  test "should update deal_chat_detail" do
    patch deal_chat_detail_url(@deal_chat_detail), params: { deal_chat_detail: { catalog: @deal_chat_detail.catalog, chat_content: @deal_chat_detail.chat_content, deal_id: @deal_chat_detail.deal_id, user_id: @deal_chat_detail.user_id } }
    assert_redirected_to deal_chat_detail_url(@deal_chat_detail)
  end

  test "should destroy deal_chat_detail" do
    assert_difference('DealChatDetail.count', -1) do
      delete deal_chat_detail_url(@deal_chat_detail)
    end

    assert_redirected_to deal_chat_details_url
  end
end

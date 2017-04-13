require 'test_helper'

class DealsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @deal = deals(:one)
  end

  test "should get index" do
    get deals_url
    assert_response :success
  end

  test "should get new" do
    get new_deal_url
    assert_response :success
  end

  test "should create deal" do
    assert_difference('Deal.count') do
      post deals_url, params: { deal: { connect_time: @deal.connect_time, deal_time: @deal.deal_time, finish_time: @deal.finish_time, offer_user_id: @deal.offer_user_id, request_user_id: @deal.request_user_id, serv_offer_id: @deal.serv_offer_id, serv_offer_title: @deal.serv_offer_title, status: @deal.status } }
    end

    assert_redirected_to deal_url(Deal.last)
  end

  test "should show deal" do
    get deal_url(@deal)
    assert_response :success
  end

  test "should get edit" do
    get edit_deal_url(@deal)
    assert_response :success
  end

  test "should update deal" do
    patch deal_url(@deal), params: { deal: { connect_time: @deal.connect_time, deal_time: @deal.deal_time, finish_time: @deal.finish_time, offer_user_id: @deal.offer_user_id, request_user_id: @deal.request_user_id, serv_offer_id: @deal.serv_offer_id, serv_offer_title: @deal.serv_offer_title, status: @deal.status } }
    assert_redirected_to deal_url(@deal)
  end

  test "should destroy deal" do
    assert_difference('Deal.count', -1) do
      delete deal_url(@deal)
    end

    assert_redirected_to deals_url
  end
end

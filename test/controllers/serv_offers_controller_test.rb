require 'test_helper'

class ServOffersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @serv_offer = serv_offers(:one)
  end

  test "should get index" do
    get serv_offers_url
    assert_response :success
  end

  test "should get new" do
    get new_serv_offer_url
    assert_response :success
  end

  test "should create serv_offer" do
    assert_difference('ServOffer.count') do
      post serv_offers_url, params: { serv_offer: { serv_catagory: @serv_offer.serv_catagory, serv_detail: @serv_offer.serv_detail, serv_images: @serv_offer.serv_images, serv_title: @serv_offer.serv_title } }
    end

    assert_redirected_to serv_offer_url(ServOffer.last)
  end

  test "should show serv_offer" do
    get serv_offer_url(@serv_offer)
    assert_response :success
  end

  test "should get edit" do
    get edit_serv_offer_url(@serv_offer)
    assert_response :success
  end

  test "should update serv_offer" do
    patch serv_offer_url(@serv_offer), params: { serv_offer: { serv_catagory: @serv_offer.serv_catagory, serv_detail: @serv_offer.serv_detail, serv_images: @serv_offer.serv_images, serv_title: @serv_offer.serv_title } }
    assert_redirected_to serv_offer_url(@serv_offer)
  end

  test "should destroy serv_offer" do
    assert_difference('ServOffer.count', -1) do
      delete serv_offer_url(@serv_offer)
    end

    assert_redirected_to serv_offers_url
  end
end

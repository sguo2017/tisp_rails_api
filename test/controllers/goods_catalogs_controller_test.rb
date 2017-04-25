require 'test_helper'

class GoodsCatalogsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @goods_catalog = goods_catalogs(:one)
  end

  test "should get index" do
    get goods_catalogs_url
    assert_response :success
  end

  test "should get new" do
    get new_goods_catalog_url
    assert_response :success
  end

  test "should create goods_catalog" do
    assert_difference('GoodsCatalog.count') do
      post goods_catalogs_url, params: { goods_catalog: { image: @goods_catalog.image, level: @goods_catalog.level, name: @goods_catalog.name } }
    end

    assert_redirected_to goods_catalog_url(GoodsCatalog.last)
  end

  test "should show goods_catalog" do
    get goods_catalog_url(@goods_catalog)
    assert_response :success
  end

  test "should get edit" do
    get edit_goods_catalog_url(@goods_catalog)
    assert_response :success
  end

  test "should update goods_catalog" do
    patch goods_catalog_url(@goods_catalog), params: { goods_catalog: { image: @goods_catalog.image, level: @goods_catalog.level, name: @goods_catalog.name } }
    assert_redirected_to goods_catalog_url(@goods_catalog)
  end

  test "should destroy goods_catalog" do
    assert_difference('GoodsCatalog.count', -1) do
      delete goods_catalog_url(@goods_catalog)
    end

    assert_redirected_to goods_catalogs_url
  end
end

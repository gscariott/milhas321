require 'test_helper'

class MilesOffersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @miles_offer = miles_offers(:one)
  end

  test "should get index" do
    get miles_offers_url
    assert_response :success
  end

  test "should get new" do
    get new_miles_offer_url
    assert_response :success
  end

  test "should create miles_offer" do
    assert_difference('MilesOffer.count') do
      post miles_offers_url, params: { miles_offer: { available: @miles_offer.available, quantity: @miles_offer.quantity, user_id: @miles_offer.user_id } }
    end

    assert_redirected_to miles_offer_url(MilesOffer.last)
  end

  test "should show miles_offer" do
    get miles_offer_url(@miles_offer)
    assert_response :success
  end

  test "should get edit" do
    get edit_miles_offer_url(@miles_offer)
    assert_response :success
  end

  test "should update miles_offer" do
    patch miles_offer_url(@miles_offer), params: { miles_offer: { available: @miles_offer.available, quantity: @miles_offer.quantity, user_id: @miles_offer.user_id } }
    assert_redirected_to miles_offer_url(@miles_offer)
  end

  test "should destroy miles_offer" do
    assert_difference('MilesOffer.count', -1) do
      delete miles_offer_url(@miles_offer)
    end

    assert_redirected_to miles_offers_url
  end
end

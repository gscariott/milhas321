require "application_system_test_case"

class MilesOffersTest < ApplicationSystemTestCase
  setup do
    @miles_offer = miles_offers(:one)
  end

  test "visiting the index" do
    visit miles_offers_url
    assert_selector "h1", text: "Miles Offers"
  end

  test "creating a Miles offer" do
    visit miles_offers_url
    click_on "New Miles Offer"

    check "Available" if @miles_offer.available
    fill_in "Quantity", with: @miles_offer.quantity
    fill_in "User", with: @miles_offer.user_id
    click_on "Create Miles offer"

    assert_text "Miles offer was successfully created"
    click_on "Back"
  end

  test "updating a Miles offer" do
    visit miles_offers_url
    click_on "Edit", match: :first

    check "Available" if @miles_offer.available
    fill_in "Quantity", with: @miles_offer.quantity
    fill_in "User", with: @miles_offer.user_id
    click_on "Update Miles offer"

    assert_text "Miles offer was successfully updated"
    click_on "Back"
  end

  test "destroying a Miles offer" do
    visit miles_offers_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Miles offer was successfully destroyed"
  end
end

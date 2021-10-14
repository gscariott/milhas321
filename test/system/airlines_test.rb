require "application_system_test_case"

class AirlinesTest < ApplicationSystemTestCase
  setup do
    @airline = airlines(:one)
  end

  test "visiting the index" do
    visit airlines_url
    assert_selector "h1", text: "Airlines"
  end

  test "creating a Airline" do
    visit airlines_url
    click_on "New Airline"

    fill_in "Cpnj", with: @airline.cpnj
    fill_in "Name", with: @airline.name
    fill_in "User", with: @airline.user_id
    click_on "Create Airline"

    assert_text "Airline was successfully created"
    click_on "Back"
  end

  test "updating a Airline" do
    visit airlines_url
    click_on "Edit", match: :first

    fill_in "Cpnj", with: @airline.cpnj
    fill_in "Name", with: @airline.name
    fill_in "User", with: @airline.user_id
    click_on "Update Airline"

    assert_text "Airline was successfully updated"
    click_on "Back"
  end

  test "destroying a Airline" do
    visit airlines_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Airline was successfully destroyed"
  end
end

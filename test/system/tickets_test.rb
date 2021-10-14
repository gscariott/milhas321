require "application_system_test_case"

class TicketsTest < ApplicationSystemTestCase
  setup do
    @ticket = tickets(:one)
  end

  test "visiting the index" do
    visit tickets_url
    assert_selector "h1", text: "Tickets"
  end

  test "creating a Ticket" do
    visit tickets_url
    click_on "New Ticket"

    fill_in "Airline", with: @ticket.airline_id
    fill_in "Airplane", with: @ticket.airplane
    fill_in "Batch", with: @ticket.batch
    fill_in "Departure", with: @ticket.departure
    fill_in "Flight", with: @ticket.flight
    fill_in "From", with: @ticket.from
    fill_in "Max cancellation date", with: @ticket.max_cancellation_date
    fill_in "To", with: @ticket.to
    fill_in "Value", with: @ticket.value
    click_on "Create Ticket"

    assert_text "Ticket was successfully created"
    click_on "Back"
  end

  test "updating a Ticket" do
    visit tickets_url
    click_on "Edit", match: :first

    fill_in "Airline", with: @ticket.airline_id
    fill_in "Airplane", with: @ticket.airplane
    fill_in "Batch", with: @ticket.batch
    fill_in "Departure", with: @ticket.departure
    fill_in "Flight", with: @ticket.flight
    fill_in "From", with: @ticket.from
    fill_in "Max cancellation date", with: @ticket.max_cancellation_date
    fill_in "To", with: @ticket.to
    fill_in "Value", with: @ticket.value
    click_on "Update Ticket"

    assert_text "Ticket was successfully updated"
    click_on "Back"
  end

  test "destroying a Ticket" do
    visit tickets_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Ticket was successfully destroyed"
  end
end

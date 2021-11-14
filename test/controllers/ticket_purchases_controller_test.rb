require 'test_helper'

class TicketPurchasesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @ticket_purchase = ticket_purchases(:one)
  end

  test "should get index" do
    get ticket_purchases_url
    assert_response :success
  end

  test "should get new" do
    get new_ticket_purchase_url
    assert_response :success
  end

  test "should create ticket_purchase" do
    assert_difference('TicketPurchase.count') do
      post ticket_purchases_url, params: { ticket_purchase: { user_id: @ticket_purchase.user_id, cancelled_at: @ticket_purchase.cancelled_at, airline_id: @ticket_purchase.airline_id, ticket_id: @ticket_purchase.ticket_id } }
    end

    assert_redirected_to ticket_purchase_url(TicketPurchase.last)
  end

  test "should show ticket_purchase" do
    get ticket_purchase_url(@ticket_purchase)
    assert_response :success
  end

  test "should get edit" do
    get edit_ticket_purchase_url(@ticket_purchase)
    assert_response :success
  end

  test "should update ticket_purchase" do
    patch ticket_purchase_url(@ticket_purchase), params: { ticket_purchase: { user_id: @ticket_purchase.user_id, cancelled_at: @ticket_purchase.cancelled_at, airline_id: @ticket_purchase.airline_id, ticket_id: @ticket_purchase.ticket_id } }
    assert_redirected_to ticket_purchase_url(@ticket_purchase)
  end

  test "should destroy ticket_purchase" do
    assert_difference('TicketPurchase.count', -1) do
      delete ticket_purchase_url(@ticket_purchase)
    end

    assert_redirected_to ticket_purchases_url
  end
end

json.extract! ticket_purchase, :id, :user_id, :airline_id, :ticket_id, :cancelled_at, :created_at, :updated_at
json.url ticket_purchase_url(ticket_purchase, format: :json)

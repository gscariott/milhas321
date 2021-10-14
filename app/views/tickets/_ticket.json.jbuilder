json.extract! ticket, :id, :airline_id, :flight, :batch, :max_cancellation_date, :departure, :from, :to, :value, :airplane, :created_at, :updated_at
json.url ticket_url(ticket, format: :json)

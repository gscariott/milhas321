class CreateTicketPurchases < ActiveRecord::Migration[5.2]
  def change
    create_table :ticket_purchases do |t|
      t.references :user, foreign_key: true
      t.references :airline, foreign_key: true
      t.references :ticket, foreign_key: true
      t.string :payment_method
      t.datetime :cancelled_at

      t.timestamps
    end
  end
end

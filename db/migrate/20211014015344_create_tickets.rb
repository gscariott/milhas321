class CreateTickets < ActiveRecord::Migration[5.2]
  def change
    create_table :tickets do |t|
      t.references :airline, foreign_key: true
      t.string :flight
      t.string :batch
      t.datetime :max_cancellation_date
      t.datetime :departure
      t.string :from
      t.string :to
      t.decimal :value
      t.string :airplane

      t.timestamps
    end
  end
end

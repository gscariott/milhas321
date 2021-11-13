class CreateMilesOffers < ActiveRecord::Migration[5.2]
  def change
    create_table :miles_offers do |t|
      t.integer :quantity
      t.boolean :available, default: true
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end

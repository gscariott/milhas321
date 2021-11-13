class CreateSites < ActiveRecord::Migration[5.2]
  def change
    create_table :sites do |t|
      t.decimal :mile_price

      t.timestamps
    end
  end
end

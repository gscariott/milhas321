class CreateAirlines < ActiveRecord::Migration[5.2]
  def change
    create_table :airlines do |t|
      t.string :name
      t.integer :cpnj
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end

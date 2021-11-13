class CreateBankAccounts < ActiveRecord::Migration[5.2]
  def change
    create_table :bank_accounts do |t|
      t.integer :credit_card_number
      t.decimal :balance
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end

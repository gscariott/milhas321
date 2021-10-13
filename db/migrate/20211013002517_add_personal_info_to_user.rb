class AddPersonalInfoToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :name, :string, limit: 191
    add_column :users, :cpf_cnpj, :integer
    add_column :users, :user_type, :integer, limit: 1
  end
end
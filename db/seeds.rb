# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require 'csv'

puts "*** Seeding ***"

puts "Creating 'admin' user"
User.create(name: 'admin', email: 'admin@milhas321.com', cpf_cnpj: 1234567, user_type: 2, miles: 1000, password: 'admin')

puts "Creating 'Azul' airline user"
User.create(name: 'Azul', email: 'azul@azul.com', cpf_cnpj: 123456789, user_type: 1, miles: 0, password: '123')

puts "Creating one batch for Azul"
batch_params = {
  flight: 'M321',
  airplane: 'BO747A',
  departure: Time.now + 10.days,
  max_cancellation_date: Time.now + 9.days,
  from: 'Porto Alegre',
  to: 'Rio de Janeiro',
  value: 321.10,
  airline: Airline.first
}
10.times { Ticket.create(batch_params) }

puts "Creating default site"
Site.create(mile_price: 0.5)

puts "Creating CSV files for CreditCard::Miles API"
generated_codes = [
  ['m1', 10],
  ['m2', 25],
  ['m3', 50],
  ['m4', 15],
  ['m5', 30],
  ['m6', 55],
  ['m7', 100],
]
redeemed_codes = [
  ['m4', 15],
  ['m5', 30],
  ['m6', 55],
]
CSV.open("lib/credit_card/generated_codes.csv", "w") do |csv|
  generated_codes.each do |code|
    csv << code
  end
end
CSV.open("lib/credit_card/redeemed_codes.csv", "w") do |csv|
  redeemed_codes.each do |code|
    csv << code
  end
end

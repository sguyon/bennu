# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)



##### ROLES
puts 'CREATING ROLES'
Role.destroy_all
Role.create([
  { :name => 'admin' }, 
  { :name => 'user' }
], :without_protection => true)

##### USERS
puts 'SETTING UP DEFAULT USER LOGIN'
User.destroy_all
user = User.create! :name => 'Bennu Admin', :email => 'sacha.guyon@gmail.com', :password => 'admin1', :password_confirmation => 'admin1'
user.confirm!
puts 'New user created: ' << user.name
user2 = User.create! :name => 'Manufacturer 1', :email => 'manufacturer@email.com', :password => 'manufacturer', :password_confirmation => 'manufacturer'
user2.confirm!
puts 'New user created: ' << user2.name
user.add_role :admin
user2.add_role :user

##### MESSAGES
Message.create([
  {
    :name => "french product 1",
    :error => "Ce n'est pas le bon produit",
    :confirm => "Verification OK, c'est bien un produit 1"
  },
  {
    :name => "french product 2",
    :error => "Ce n'est pas le bon produit",
    :confirm => "Verification OK, c'est bien un produit 2"
  },
  {
    :name => "english product 1",
    :error => "This is not the good product",
    :confirm => "Verification OK, it is a product 1"
  }
])


##### STICKERS







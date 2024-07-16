# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
require 'faker'
UserTag.destroy_all
User.destroy_all

ruby_on_rails = Tag.create!({ name: "Ruby on Rails", icon_url: "#" })
javascript = Tag.create!({ name: "Javascript", icon_url: "#" })
css = Tag.create!({ name: "CSS", icon_url: "#" })

5.times do
  User.create!(
    {
      first_name: Faker::Name.first_name,
      last_name: Faker::Name.last_name,
      email: Faker::Internet.email,
      password: "Password1234",
      username: Faker::Internet.username,
      address: Faker::Address.city
    }
  )
end

5.times do
  interviewer = User.new(
    {
      first_name: Faker::Name.first_name,
      last_name: Faker::Name.last_name,
      email: Faker::Internet.email,
      password: "Password1234",
      username: Faker::Internet.username,
      address: Faker::Address.city,
      interviewer: true,
      years_experience: 6,
      headline: "This is my tagline",
      about: "This is a story all about how my life got flipped on upside down"
    }
  )
  interviewer.save!

  UserTag.create!({ user: interviewer, tag: ruby_on_rails })
  UserTag.create!({ user: interviewer, tag: javascript })
  UserTag.create!({ user: interviewer, tag: css })

end

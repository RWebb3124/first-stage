require 'faker'
require "open-uri"

UserTag.destroy_all
User.destroy_all
Tag.destroy_all

tags = [
  { name: "RoR", icon_url: "ruby_on_rails.png" },
  { name: "Javascript", icon_url: "javascript.png" },
  { name: "CSS", icon_url: "css.png" },
  { name: "Ruby", icon_url: "ruby.png" },
  { name: "Python", icon_url: "python.png" },
  { name: "C++", icon_url: "cplusplus.png" },
  { name: "Docker", icon_url: "docker.png" },
  { name: "HTML", icon_url: "html.png" },
  { name: "Kubernetes", icon_url: "kubernetes.png" }
]

tags.each { |tag| Tag.create!(tag) }

def attach_profile_picture(user, url)
  file = URI.open(url)
  user.photo.attach(io: file, filename: "profile_picture_#{user.id}.png", content_type: "image/png")
  user.save!
end

def create_user(attributes, tags = [], image_url)
  user = User.new(attributes)
  user.save!
  attach_profile_picture(user, image_url)

  tags.each do |tag|
    UserTag.create!(user: user, tag: tag)
  end
end

10.times do
  create_user(
    {
      first_name: Faker::Name.first_name,
      last_name: Faker::Name.last_name,
      email: Faker::Internet.email,
      password: "Password1234",
      username: Faker::Internet.username,
      address: Faker::Address.city
    },
    [],
    "https://randomuser.me/api/portraits/men/#{rand(1..99)}.jpg"
  )
end

interviewer_image_urls = [
  "https://randomuser.me/api/portraits/women/#{rand(1..99)}.jpg",
  "https://randomuser.me/api/portraits/men/#{rand(1..99)}.jpg",
  "https://randomuser.me/api/portraits/women/#{rand(1..99)}.jpg",
  "https://randomuser.me/api/portraits/men/#{rand(1..99)}.jpg",
  "https://randomuser.me/api/portraits/women/#{rand(1..99)}.jpg",
  "https://randomuser.me/api/portraits/men/#{rand(1..99)}.jpg",
  "https://randomuser.me/api/portraits/women/#{rand(1..99)}.jpg",
  "https://randomuser.me/api/portraits/men/#{rand(1..99)}.jpg",
  "https://randomuser.me/api/portraits/women/#{rand(1..99)}.jpg",
  "https://randomuser.me/api/portraits/men/#{rand(1..99)}.jpg"
]

10.times do |i|
  create_user(
    {
      first_name: Faker::Name.first_name,
      last_name: Faker::Name.last_name,
      email: Faker::Internet.email,
      password: "Password1234",
      username: Faker::Internet.username,
      address: Faker::Address.city,
      interviewer: true,
      years_experience: rand(1..9),
      headline: "Passionate full-stack developer with a love for innovative solutions.",
      about: "With over #{rand(1..9)} years of experience, I specialize in building dynamic web applications using modern technologies like Ruby on Rails and React. I thrive on solving complex problems and improving user experiences through efficient code and design.",
      github: "https://github.com/#{Faker::Internet.username}",
      linkedin: "https://www.linkedin.com/in/#{Faker::Internet.username}",
      fiverr: "https://www.fiverr.com/#{Faker::Internet.username}",
      personal_website: "https://en.wikipedia.org/wiki/#{Faker::Lorem.word.capitalize}"
    },
    Tag.all.sample(3),
    interviewer_image_urls[i]
  )
end

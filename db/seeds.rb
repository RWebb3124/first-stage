require 'faker'
require 'open-uri'

Booking.destroy_all
Chatroom.destroy_all
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

def attach_profile_picture(user, profile_url, banner_url)
  profile_file = URI.open(profile_url)
  user.photo.attach(io: profile_file, filename: "profile_picture_#{user.id}.png", content_type: "image/png")

  banner_file = URI.open(banner_url)
  user.banner_photo.attach(io: banner_file, filename: "banner_photo_#{user.id}.png", content_type: "image/png")

  user.save!
end

def create_user(attributes, tags = [], profile_image_url, banner_image_url)
  user = User.new(attributes)
  user.save!
  attach_profile_picture(user, profile_image_url, banner_image_url)

  tags.each do |tag|
    UserTag.create!(user: user, tag: tag)
  end
end

banner_image_urls = [
  "https://media.istockphoto.com/id/1284817090/photo/space-motion.jpg?s=1024x1024&w=is&k=20&c=yBGWceG8sgDK7qILtLDrAh3PvpR-fUshu-lSCLHDZHc=",
  "https://cdn.pixabay.com/photo/2016/05/27/08/51/mobile-phone-1419275_1280.jpg",
  "https://cdn.pixabay.com/photo/2023/03/11/15/28/puddle-7844705_1280.jpg",
  "https://cdn.pixabay.com/photo/2022/06/12/22/48/gradient-7258997_1280.png",
  "https://cdn.pixabay.com/photo/2016/08/05/09/31/banner-1571858_1280.jpg",
  "https://cdn.pixabay.com/photo/2016/09/01/19/53/pocket-watch-1637396_1280.jpg",
  "https://cdn.pixabay.com/photo/2017/09/21/14/05/animals-2772006_1280.jpg",
  "https://cdn.pixabay.com/photo/2016/08/03/09/03/universe-1566159_1280.jpg",
  "https://cdn.pixabay.com/photo/2016/09/04/20/14/sunset-1645103_1280.jpg",
  "https://cdn.pixabay.com/photo/2015/12/15/09/04/banner-1093909_1280.jpg"
]

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
    "https://randomuser.me/api/portraits/men/#{rand(1..99)}.jpg",
    banner_image_urls.sample
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
  rand_num = rand(1..9)
  create_user(
    {
      first_name: Faker::Name.first_name,
      last_name: Faker::Name.last_name,
      email: Faker::Internet.email,
      password: "Password1234",
      username: Faker::Internet.username,
      address: Faker::Address.city,
      interviewer: true,
      years_experience: rand_num,
      headline: "Passionate full-stack developer with a love for innovative solutions.",
      about: "With over #{rand_num} years of experience, I specialize in building dynamic web applications using modern technologies like Ruby on Rails and React. I thrive on solving complex problems and improving user experiences through efficient code and design.",
      github: "https://github.com/#{Faker::Internet.username}",
      linkedin: "https://www.linkedin.com/in/#{Faker::Internet.username}",
      fiverr: "https://www.fiverr.com/#{Faker::Internet.username}",
      personal_website: "https://en.wikipedia.org/wiki/#{Faker::Lorem.word.capitalize}"
    },
    Tag.all.sample(3),
    interviewer_image_urls[i],
    banner_image_urls.sample
  )
end

# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end


User.destroy_all
Post.destroy_all
Tag.destroy_all

user = User.create!(email: "test@example.com", password: "123456")

tags = %w[ruby rails dev turbo stimulus].map { |name| Tag.create!(name: name) }

5.times do |i|
  post = Post.create!(
    title: "Post #{i + 1}",
    body: "Contenido del post #{i + 1}. Lorem ipsum dolor sit amet.",
    user: user
  )
  post.tags << tags.sample(2)
end

Post.first.comments.create!(body: "Buen post", user: user)
Post.first.reactions.create!(kind: "like", user: user)

puts "Seed completado."

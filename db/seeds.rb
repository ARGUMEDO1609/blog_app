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

User.create!(email: "admin@example.com", password: "123456")

5.times do |i|
  post = Post.create!(
    title: "Post de ejemplo #{i + 1}",
    body: "Este es el contenido del post número #{i + 1}.",
    user: User.first
  )

  3.times do |j|
    Comment.create!(
      body: "Comentario #{j + 1} para el post #{i + 1}",
      commentable: post,
      user: User.first
    )
  end

  ["rails", "ruby", "dev"].each do |tag_name|
    tag = Tag.find_or_create_by!(name: tag_name)
    post.tags << tag unless post.tags.include?(tag)
  end
end


puts "Seed completado."

require 'rails_helper'

RSpec.describe Post, type: :model do
  it "es válido con título, cuerpo y usuario" do
    user = User.create(email: "test@example.com", password: "123456")
    post = Post.new(title: "Post", body: "Contenido", user: user)
    expect(post).to be_valid
  end
end

require_relative "../app.rb"

users = [
  { name: "Yuki Akamatsu" },
  { name: "Atsuya Sato" }
]

akamatsu = User.create!(users[0])
sato = User.create!(users[1])

Todo.create!(user_id: akamatsu.id, name: "牛乳を買う")
Todo.create!(user_id: akamatsu.id, name: "部屋を片付ける")

Todo.create!(user_id: sato.id, name: "本を読む")

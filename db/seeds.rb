# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

ReviewResult.create([
  {name: "I feel fine or neutral", emoji: "https://i.stack.imgur.com/f22Ua.png"}, # "\u{1F642}"
  {name: "I feel unsure or annoyed", emoji: "https://i.stack.imgur.com/gsUPY.png"}, # "\u{1F928}"
  {name: "I feel angry or upset", emoji: "https://i.stack.imgur.com/1YKEn.png"} # "\u{1F92C}"
])

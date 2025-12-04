# Clear dependent tables first (children)
OrderItem.delete_all if defined?(OrderItem)
LineItem.delete_all  if defined?(LineItem)
Order.delete_all     if defined?(Order)
Cart.delete_all      if defined?(Cart)
User.delete_all
# Then clear products & categories
Product.delete_all   if defined?(Product)
Category.delete_all  if defined?(Category)
require 'faker'



racquets     = Category.find_or_create_by!(name: 'Racquets')
strings      = Category.find_or_create_by!(name: 'Strings')
shoes        = Category.find_or_create_by!(name: 'Shoes')
clothes      = Category.find_or_create_by!(name: 'Clothes')


puts "Categories created."


# --------------------------
# STRINGS (3 products)
# --------------------------
puts "Seeding string products..."

Product.find_or_create_by!(name: "Yonex BG80") do |p|
  p.description = "High-performance hard-feel string known for repulsion and control."
  p.current_price = 14.99
  p.category = strings
end

Product.find_or_create_by!(name: "Yonex BG65Ti") do |p|
  p.description = "Durable titanium-coated string offering a crisp hitting feel."
  p.current_price = 12.99
  p.category = strings
end

Product.find_or_create_by!(name: "Yonex Aerobite") do |p|
  p.description = "Hybrid string for maximum control and spin—popular among pros."
  p.current_price = 19.99
  p.category = strings
end

puts "Strings added."


# --------------------------
# SHOES (3 products)
# --------------------------
puts "Seeding shoes..."

Product.find_or_create_by!(name: "Yonex 65Z") do |p|
  p.description = "Stable all-around badminton shoe with power cushioning."
  p.current_price = 159.99
  p.category = shoes
end

Product.find_or_create_by!(name: "Yonex Eclipsion Z") do |p|
  p.description = "High-support shoe ideal for explosive footwork and lateral movement."
  p.current_price = 179.99
  p.category = shoes
end

Product.find_or_create_by!(name: "Yonex Aerus Z") do |p|
  p.description = "Ultra-lightweight, breathable design for fast-paced players."
  p.current_price = 189.99
  p.category = shoes
end

puts "Shoes added."

puts "Seeding racquets..."

Product.find_or_create_by!(name: "Yonex Astrox 100ZZ") do |p|
  p.description = "A head-heavy, stiff badminton racquet designed for explosive power and steep smashes. Popular among advanced attacking players."
  p.current_price = 299.99
  p.category = racquets
end

Product.find_or_create_by!(name: "Yonex Nanoflare 1000Z") do |p|
  p.description = "Ultra-fast racket built for lightning-speed rallies. Designed with Aero Frame + Razor Frame for maximum repulsion."
  p.current_price = 279.99
  p.category = racquets
end

Product.find_or_create_by!(name: "Yonex Arcsaber 11 Pro") do |p|
  p.description = "Control-focused racquet offering precise shuttle placement and enhanced stability through Pocketing Booster technology."
  p.current_price = 259.99
  p.category = racquets
end

Product.find_or_create_by!(name: "Yonex Astrox 88D Pro") do |p|
  p.description = "Designed for back-court dominance, delivering power with a solid, direct feel. Excellent for smashes and rear-court drives."
  p.current_price = 249.99
  p.category = racquets
end

Product.find_or_create_by!(name: "Yonex Astrox 88S Pro") do |p|
  p.description = "Optimized for front-court specialists, offering quick control and excellent shuttle hold for net play and rapid exchanges."
  p.current_price = 239.99
  p.category = racquets
end

Product.find_or_create_by!(name: "Yonex Nanoray 10F") do |p|
  p.description = "Lightweight, beginner-friendly racquet with an easy-to-handle frame, great for players developing fast defensive play."
  p.current_price = 69.99
  p.category = racquets
end

puts "Racquets added."
# --------------------------
# CLOTHES (100 Faker products)
# --------------------------
puts "Seeding clothes..."

100.times do
  Product.create!(
    name: Faker::Commerce.product_name, 
    description: Faker::Lorem.paragraph(sentence_count: 2),
    current_price: Faker::Commerce.price(range: 19.99..89.99),
    category: clothes
  )
end

puts "100 clothing items added."


User.create!(
  name: 'admin',
  email: 'admin@example.com',
  password: 'password',
  password_confirmation: 'password',
  admin: true
)



Page.find_or_create_by!(slug: 'about') do |page|
  page.title = 'About Racquets Pro Shop'
  page.content = <<~TEXT
    Racquets Pro Shop is a Winnipeg-based badminton specialist store, focused on
    helping players at every level find the right racquets, strings, and gear.

    
  TEXT
end

Page.find_or_create_by!(slug: 'contact') do |page|
  page.title = 'Contact Us'
  page.content = <<~TEXT
    Have questions about racquets, stringing, or your order?

    Email: info@racquetsproshop.com
    Phone: (204) 293-5873
    Location: 200 River Avnue, Winnipeg, Manitoba

  TEXT
end

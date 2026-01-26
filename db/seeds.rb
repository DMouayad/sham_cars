# db/seeds.rb

puts "🌱 Seeding database..."
puts "=" * 50

# ===================
# ADMIN USER
# ===================
puts "\n👤 Creating admin user..."

admin = User.find_or_create_by!(email: "admin@arenaev.com") do |u|
  u.password = "password123"
  u.role = :super_admin
  u.name = "Admin User"
end

puts "   ✅ Admin: #{admin.email} / password123"

# ===================
# BODY TYPES
# ===================
puts "\n🚗 Creating body types..."

body_types_data = [
  { name: "Sedan", icon: "🚗" },
  { name: "SUV", icon: "🚙" },
  { name: "Hatchback", icon: "🚘" },
  { name: "Truck", icon: "🛻" },
  { name: "Van", icon: "🚐" },
  { name: "Coupe", icon: "🏎️" },
  { name: "Wagon", icon: "🚃" },
  { name: "Crossover", icon: "🚙" }
]

body_types_data.each do |data|
  BodyType.find_or_create_by!(name: data[:name]) do |bt|
    bt.icon = data[:icon]
  end
end

puts "   ✅ Created #{BodyType.count} body types"

# ===================
# BRANDS
# ===================
puts "\n🏭 Creating brands..."

brands_data = [
  { name: "Tesla", country: "USA", website: "https://tesla.com" },
  { name: "BMW", country: "Germany", website: "https://bmw.com" },
  { name: "Mercedes-Benz", country: "Germany", website: "https://mercedes-benz.com" },
  { name: "Audi", country: "Germany", website: "https://audi.com" },
  { name: "Porsche", country: "Germany", website: "https://porsche.com" },
  { name: "Rivian", country: "USA", website: "https://rivian.com" },
  { name: "Lucid", country: "USA", website: "https://lucidmotors.com" },
  { name: "BYD", country: "China", website: "https://byd.com" },
  { name: "NIO", country: "China", website: "https://nio.com" },
  { name: "Hyundai", country: "South Korea", website: "https://hyundai.com" },
  { name: "Kia", country: "South Korea", website: "https://kia.com" },
  { name: "Ford", country: "USA", website: "https://ford.com" },
  { name: "Volkswagen", country: "Germany", website: "https://volkswagen.com" },
  { name: "Polestar", country: "Sweden", website: "https://polestar.com" },
  { name: "Volvo", country: "Sweden", website: "https://volvocars.com" }
]

brands_data.each do |data|
  Brand.find_or_create_by!(name: data[:name]) do |b|
    b.country = data[:country]
    b.website = data[:website]
  end
end

puts "   ✅ Created #{Brand.count} brands"

# ===================
# VEHICLES
# ===================
puts "\n⚡ Creating vehicles..."

# Helper to find records
def find_brand(name)
  Brand.find_by!(name: name)
end

def find_body_type(name)
  BodyType.find_by!(name: name)
end

vehicles_data = [
  # Tesla
  {
    brand: "Tesla", body_type: "Sedan", name: "Model S Plaid", year: 2024,
    price_from: 89990, price_to: 109990, currency: "USD",
    battery_capacity_kwh: 100, range_wltp_km: 600, range_epa_miles: 390,
    acceleration_0_100: 2.1, top_speed_kmh: 322, horsepower: 1020, torque_nm: 1420,
    drive_type: "AWD", fast_charge_kw: 250, fast_charge_time_min: 25,
    seats: 5, cargo_volume_liters: 793,
    published: true, featured: true,
    description: "The Tesla Model S Plaid is the fastest accelerating production car ever made, with a 0-60 mph time of under 2 seconds."
  },
  {
    brand: "Tesla", body_type: "Sedan", name: "Model 3 Long Range", year: 2024,
    price_from: 47990, price_to: 52990, currency: "USD",
    battery_capacity_kwh: 75, range_wltp_km: 629, range_epa_miles: 333,
    acceleration_0_100: 4.4, top_speed_kmh: 233, horsepower: 366, torque_nm: 493,
    drive_type: "AWD", fast_charge_kw: 250, fast_charge_time_min: 27,
    seats: 5, cargo_volume_liters: 561,
    published: true, featured: true,
    description: "The Tesla Model 3 is the world's best-selling electric car, offering exceptional range and performance at an accessible price."
  },
  {
    brand: "Tesla", body_type: "SUV", name: "Model Y Long Range", year: 2024,
    price_from: 52990, price_to: 56990, currency: "USD",
    battery_capacity_kwh: 75, range_wltp_km: 533, range_epa_miles: 310,
    acceleration_0_100: 5.0, top_speed_kmh: 217, horsepower: 384, torque_nm: 493,
    drive_type: "AWD", fast_charge_kw: 250, fast_charge_time_min: 28,
    seats: 7, cargo_volume_liters: 854,
    published: true, featured: true,
    description: "The Tesla Model Y is a versatile electric SUV with seating for up to 7 passengers and impressive cargo space."
  },
  {
    brand: "Tesla", body_type: "Truck", name: "Cybertruck AWD", year: 2024,
    price_from: 79990, price_to: 99990, currency: "USD",
    battery_capacity_kwh: 123, range_wltp_km: 547, range_epa_miles: 340,
    acceleration_0_100: 4.1, top_speed_kmh: 180, horsepower: 600, torque_nm: 930,
    drive_type: "AWD", fast_charge_kw: 250, fast_charge_time_min: 35,
    seats: 5, cargo_volume_liters: 1897,
    published: true, featured: true,
    description: "The Tesla Cybertruck features a revolutionary exoskeleton design with ultra-hard stainless steel panels."
  },

  # BMW
  {
    brand: "BMW", body_type: "Sedan", name: "i7 xDrive60", year: 2024,
    price_from: 119300, price_to: 168500, currency: "USD",
    battery_capacity_kwh: 101.7, range_wltp_km: 625, range_epa_miles: 318,
    acceleration_0_100: 4.7, top_speed_kmh: 240, horsepower: 544, torque_nm: 745,
    drive_type: "AWD", fast_charge_kw: 195, fast_charge_time_min: 34,
    seats: 5, cargo_volume_liters: 500,
    published: true, featured: false,
    description: "The BMW i7 combines ultimate luxury with electric performance, featuring a stunning 31-inch theatre screen."
  },
  {
    brand: "BMW", body_type: "SUV", name: "iX xDrive50", year: 2024,
    price_from: 87100, price_to: 111500, currency: "USD",
    battery_capacity_kwh: 111.5, range_wltp_km: 630, range_epa_miles: 324,
    acceleration_0_100: 4.6, top_speed_kmh: 200, horsepower: 523, torque_nm: 765,
    drive_type: "AWD", fast_charge_kw: 200, fast_charge_time_min: 35,
    seats: 5, cargo_volume_liters: 500,
    published: true, featured: true,
    description: "The BMW iX is a technology flagship with sustainable materials and cutting-edge electric drivetrain."
  },
  {
    brand: "BMW", body_type: "Sedan", name: "i4 M50", year: 2024,
    price_from: 67300, price_to: 72900, currency: "USD",
    battery_capacity_kwh: 83.9, range_wltp_km: 521, range_epa_miles: 271,
    acceleration_0_100: 3.9, top_speed_kmh: 225, horsepower: 544, torque_nm: 795,
    drive_type: "AWD", fast_charge_kw: 200, fast_charge_time_min: 31,
    seats: 5, cargo_volume_liters: 470,
    published: true, featured: false,
    description: "The BMW i4 M50 delivers M performance in an all-electric package with thrilling driving dynamics."
  },

  # Mercedes-Benz
  {
    brand: "Mercedes-Benz", body_type: "Sedan", name: "EQS 580 4MATIC", year: 2024,
    price_from: 125950, price_to: 147500, currency: "USD",
    battery_capacity_kwh: 107.8, range_wltp_km: 676, range_epa_miles: 350,
    acceleration_0_100: 4.3, top_speed_kmh: 210, horsepower: 523, torque_nm: 855,
    drive_type: "AWD", fast_charge_kw: 200, fast_charge_time_min: 31,
    seats: 5, cargo_volume_liters: 610,
    published: true, featured: true,
    description: "The Mercedes EQS is the electric S-Class, featuring the stunning MBUX Hyperscreen dashboard."
  },
  {
    brand: "Mercedes-Benz", body_type: "SUV", name: "EQE SUV 350+", year: 2024,
    price_from: 77900, price_to: 89900, currency: "USD",
    battery_capacity_kwh: 90.6, range_wltp_km: 558, range_epa_miles: 288,
    acceleration_0_100: 6.6, top_speed_kmh: 210, horsepower: 288, torque_nm: 565,
    drive_type: "RWD", fast_charge_kw: 170, fast_charge_time_min: 32,
    seats: 5, cargo_volume_liters: 520,
    published: true, featured: false,
    description: "The Mercedes EQE SUV combines electric efficiency with spacious luxury in an elegant package."
  },

  # Porsche
  {
    brand: "Porsche", body_type: "Sedan", name: "Taycan Turbo S", year: 2024,
    price_from: 185000, price_to: 205000, currency: "USD",
    battery_capacity_kwh: 93.4, range_wltp_km: 507, range_epa_miles: 280,
    acceleration_0_100: 2.8, top_speed_kmh: 260, horsepower: 750, torque_nm: 1050,
    drive_type: "AWD", fast_charge_kw: 270, fast_charge_time_min: 22,
    seats: 4, cargo_volume_liters: 366,
    published: true, featured: true,
    description: "The Porsche Taycan Turbo S delivers true sports car performance with groundbreaking electric technology."
  },
  {
    brand: "Porsche", body_type: "Wagon", name: "Taycan 4S Cross Turismo", year: 2024,
    price_from: 117900, price_to: 135000, currency: "USD",
    battery_capacity_kwh: 93.4, range_wltp_km: 490, range_epa_miles: 265,
    acceleration_0_100: 4.1, top_speed_kmh: 240, horsepower: 490, torque_nm: 650,
    drive_type: "AWD", fast_charge_kw: 270, fast_charge_time_min: 22,
    seats: 4, cargo_volume_liters: 446,
    published: true, featured: false,
    description: "The Taycan Cross Turismo adds versatility and rugged styling to the acclaimed Taycan platform."
  },

  # Rivian
  {
    brand: "Rivian", body_type: "Truck", name: "R1T Adventure", year: 2024,
    price_from: 73000, price_to: 95000, currency: "USD",
    battery_capacity_kwh: 135, range_wltp_km: 505, range_epa_miles: 314,
    acceleration_0_100: 3.0, top_speed_kmh: 201, horsepower: 835, torque_nm: 1231,
    drive_type: "AWD", fast_charge_kw: 220, fast_charge_time_min: 35,
    seats: 5, cargo_volume_liters: 1100,
    published: true, featured: false,
    description: "The Rivian R1T is the first electric adventure truck, combining off-road capability with innovative features."
  },
  {
    brand: "Rivian", body_type: "SUV", name: "R1S Adventure", year: 2024,
    price_from: 78000, price_to: 98000, currency: "USD",
    battery_capacity_kwh: 135, range_wltp_km: 488, range_epa_miles: 303,
    acceleration_0_100: 3.0, top_speed_kmh: 201, horsepower: 835, torque_nm: 1231,
    drive_type: "AWD", fast_charge_kw: 220, fast_charge_time_min: 35,
    seats: 7, cargo_volume_liters: 891,
    published: true, featured: false,
    description: "The Rivian R1S is a three-row electric SUV built for adventure with impressive off-road capabilities."
  },

  # Lucid
  {
    brand: "Lucid", body_type: "Sedan", name: "Air Grand Touring", year: 2024,
    price_from: 138000, price_to: 179000, currency: "USD",
    battery_capacity_kwh: 112, range_wltp_km: 830, range_epa_miles: 516,
    acceleration_0_100: 3.0, top_speed_kmh: 270, horsepower: 819, torque_nm: 1150,
    drive_type: "AWD", fast_charge_kw: 300, fast_charge_time_min: 20,
    seats: 5, cargo_volume_liters: 627,
    published: true, featured: true,
    description: "The Lucid Air offers the longest range of any EV with over 500 miles on a single charge."
  },

  # Hyundai
  {
    brand: "Hyundai", body_type: "Sedan", name: "IONIQ 6 Long Range", year: 2024,
    price_from: 46615, price_to: 56715, currency: "USD",
    battery_capacity_kwh: 77.4, range_wltp_km: 614, range_epa_miles: 361,
    acceleration_0_100: 5.1, top_speed_kmh: 185, horsepower: 325, torque_nm: 605,
    drive_type: "AWD", fast_charge_kw: 240, fast_charge_time_min: 18,
    seats: 5, cargo_volume_liters: 401,
    published: true, featured: false,
    description: "The Hyundai IONIQ 6 is a sleek electric sedan with exceptional efficiency and ultra-fast charging."
  },
  {
    brand: "Hyundai", body_type: "SUV", name: "IONIQ 5 Long Range", year: 2024,
    price_from: 52500, price_to: 62500, currency: "USD",
    battery_capacity_kwh: 77.4, range_wltp_km: 507, range_epa_miles: 303,
    acceleration_0_100: 5.2, top_speed_kmh: 185, horsepower: 325, torque_nm: 605,
    drive_type: "AWD", fast_charge_kw: 240, fast_charge_time_min: 18,
    seats: 5, cargo_volume_liters: 527,
    published: true, featured: false,
    description: "The Hyundai IONIQ 5 features retro-futuristic styling and segment-leading charging speeds."
  },

  # Kia
  {
    brand: "Kia", body_type: "SUV", name: "EV9 GT-Line AWD", year: 2024,
    price_from: 73900, price_to: 79900, currency: "USD",
    battery_capacity_kwh: 99.8, range_wltp_km: 512, range_epa_miles: 304,
    acceleration_0_100: 5.3, top_speed_kmh: 200, horsepower: 379, torque_nm: 700,
    drive_type: "AWD", fast_charge_kw: 240, fast_charge_time_min: 24,
    seats: 7, cargo_volume_liters: 828,
    published: true, featured: true,
    description: "The Kia EV9 is a bold three-row electric SUV with impressive space and advanced technology."
  },
  {
    brand: "Kia", body_type: "Crossover", name: "EV6 GT-Line", year: 2024,
    price_from: 52900, price_to: 61900, currency: "USD",
    battery_capacity_kwh: 77.4, range_wltp_km: 528, range_epa_miles: 310,
    acceleration_0_100: 5.2, top_speed_kmh: 188, horsepower: 325, torque_nm: 605,
    drive_type: "AWD", fast_charge_kw: 240, fast_charge_time_min: 18,
    seats: 5, cargo_volume_liters: 490,
    published: true, featured: false,
    description: "The Kia EV6 combines stunning design with 800V architecture for ultra-fast charging."
  },

  # Volkswagen
  {
    brand: "Volkswagen", body_type: "SUV", name: "ID.4 Pro S", year: 2024,
    price_from: 44995, price_to: 52995, currency: "USD",
    battery_capacity_kwh: 82, range_wltp_km: 531, range_epa_miles: 275,
    acceleration_0_100: 6.5, top_speed_kmh: 180, horsepower: 286, torque_nm: 545,
    drive_type: "RWD", fast_charge_kw: 170, fast_charge_time_min: 30,
    seats: 5, cargo_volume_liters: 543,
    published: true, featured: false,
    description: "The Volkswagen ID.4 is a practical family electric SUV with spacious interior and good range."
  },

  # Polestar
  {
    brand: "Polestar", body_type: "Sedan", name: "Polestar 2 Long Range", year: 2024,
    price_from: 49800, price_to: 56800, currency: "USD",
    battery_capacity_kwh: 82, range_wltp_km: 592, range_epa_miles: 320,
    acceleration_0_100: 4.2, top_speed_kmh: 205, horsepower: 421, torque_nm: 740,
    drive_type: "AWD", fast_charge_kw: 205, fast_charge_time_min: 28,
    seats: 5, cargo_volume_liters: 405,
    published: true, featured: false,
    description: "The Polestar 2 is a performance-focused electric fastback with Scandinavian design."
  },

  # Volvo
  {
    brand: "Volvo", body_type: "SUV", name: "EX90 Twin Motor", year: 2024,
    price_from: 79995, price_to: 89995, currency: "USD",
    battery_capacity_kwh: 111, range_wltp_km: 585, range_epa_miles: 310,
    acceleration_0_100: 4.9, top_speed_kmh: 180, horsepower: 496, torque_nm: 770,
    drive_type: "AWD", fast_charge_kw: 250, fast_charge_time_min: 30,
    seats: 7, cargo_volume_liters: 655,
    published: true, featured: false,
    description: "The Volvo EX90 is a luxury electric SUV with world-leading safety technology and sustainable materials."
  },

  # Ford
  {
    brand: "Ford", body_type: "SUV", name: "Mustang Mach-E GT", year: 2024,
    price_from: 59995, price_to: 69995, currency: "USD",
    battery_capacity_kwh: 91, range_wltp_km: 490, range_epa_miles: 280,
    acceleration_0_100: 3.7, top_speed_kmh: 200, horsepower: 480, torque_nm: 860,
    drive_type: "AWD", fast_charge_kw: 150, fast_charge_time_min: 45,
    seats: 5, cargo_volume_liters: 519,
    published: true, featured: false,
    description: "The Ford Mustang Mach-E GT brings pony car performance to the electric age."
  },
  {
    brand: "Ford", body_type: "Truck", name: "F-150 Lightning Lariat", year: 2024,
    price_from: 69995, price_to: 91995, currency: "USD",
    battery_capacity_kwh: 131, range_wltp_km: 483, range_epa_miles: 300,
    acceleration_0_100: 4.0, top_speed_kmh: 180, horsepower: 580, torque_nm: 1050,
    drive_type: "AWD", fast_charge_kw: 150, fast_charge_time_min: 44,
    seats: 5, cargo_volume_liters: 1495,
    published: true, featured: false,
    description: "The Ford F-150 Lightning electrifies America's best-selling truck with impressive capability."
  }
]

vehicles_data.each do |data|
  brand = find_brand(data[:brand])
  body_type = find_body_type(data[:body_type])

  vehicle = Vehicle.find_or_initialize_by(name: data[:name], brand: brand)

  vehicle.assign_attributes(
    body_type: body_type,
    year: data[:year],
    price_from: data[:price_from],
    price_to: data[:price_to],
    currency: data[:currency],
    battery_capacity_kwh: data[:battery_capacity_kwh],
    range_wltp_km: data[:range_wltp_km],
    range_epa_miles: data[:range_epa_miles],
    acceleration_0_100: data[:acceleration_0_100],
    top_speed_kmh: data[:top_speed_kmh],
    horsepower: data[:horsepower],
    torque_nm: data[:torque_nm],
    drive_type: data[:drive_type],
    fast_charge_kw: data[:fast_charge_kw],
    fast_charge_time_min: data[:fast_charge_time_min],
    seats: data[:seats],
    cargo_volume_liters: data[:cargo_volume_liters],
    published: data[:published],
    featured: data[:featured],
    description: data[:description]
  )

  vehicle.save!
  print "."
end

puts "\n   ✅ Created #{Vehicle.count} vehicles"

# ===================
# SUMMARY
# ===================
puts "\n" + "=" * 50
puts "✅ SEEDING COMPLETE!"
puts "=" * 50
puts "   👤 Users: #{User.count}"
puts "   🏭 Brands: #{Brand.count}"
puts "   🚗 Body Types: #{BodyType.count}"
puts "   ⚡ Vehicles: #{Vehicle.count}"
puts "   🖼️  Vehicle Images: #{VehicleImage.count}"
puts "\n   Admin login: admin@arenaev.com / password123"
puts "=" * 50

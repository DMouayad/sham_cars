
puts "== Seeding SY community (AR, city-based, non-admin) =="

CITIES = %w[damascus aleppo homs latakia].freeze
PASSWORD = "password123456" # >= 12

admins = User.where(role: User.roles[:admin]).to_a
puts "Admins kept: #{admins.map(&:email).join(", ")}"

# Clean non-admin users (dependent data will be destroyed)
User.where.not(role: User.roles[:admin]).destroy_all
puts "Deleted non-admin users."

# Also ensure no admin content remains in community tables
Review.joins(:user).where(users: { role: User.roles[:admin] }).destroy_all
Question.joins(:user).where(users: { role: User.roles[:admin] }).destroy_all
Answer.joins(:user).where(users: { role: User.roles[:admin] }).destroy_all
puts "Cleaned admin-made reviews/questions/answers."

male_first = %w[ahmad mohammad omar ali yousef khaled mahmoud abdullah hamza hassan tamer rami bassel]
female_first = %w[rana sara dana reem lama maram yara aya hiba jana lynn salma farah]
last_names = %w[alhassan alkhatib alsayed alali alnajjar alhamwi alsabbagh alqarra alkhoury alhajjar]

themes = User.themes.keys

def unique_username(base)
  base = base.downcase.gsub(/[^a-z0-9_-]/, "")
  suffix = rand(1000..9999)
  candidate = "#{base}_#{suffix}"
  while User.exists?(username: candidate)
    suffix = rand(1000..9999)
    candidate = "#{base}_#{suffix}"
  end
  candidate
end

def city_ar(code)
  # Keep mapping here so seeds can run without I18n
  {
    "damascus" => "دمشق",
    "aleppo"   => "حلب",
    "homs"     => "حمص",
    "latakia"  => "اللاذقية"
  }.fetch(code)
end

def with_city(text, city_ar)
  text.to_s.gsub("%{city}", city_ar.to_s)
end

puts "Creating users..."
users = []

# ~12 users per city => 48 total
CITIES.each do |city|
  6.times do
    first = male_first.sample
    last  = last_names.sample
    username = unique_username("#{first}_#{last}")
    users << User.create!(
      email: "#{username}@example.com",
      username: username,
      password: PASSWORD,
      password_confirmation: PASSWORD,
      role: :user,
      verified: true,
      theme: themes.sample,
      city: city
    )
  end

  6.times do
    first = female_first.sample
    last  = last_names.sample
    username = unique_username("#{first}_#{last}")
    users << User.create!(
      email: "#{username}@example.com",
      username: username,
      password: PASSWORD,
      password_confirmation: PASSWORD,
      role: :user,
      verified: true,
      theme: themes.sample,
      city: city
    )
  end
end

puts "Users created: #{users.count}"

vehicles = Vehicle.where(published: true).to_a
vehicles = Vehicle.all.to_a if vehicles.empty?
raise "No vehicles found. Seed vehicles first." if vehicles.empty?

puts "Vehicles available: #{vehicles.count}"

# -----------------------------
# Reviews (Arabic, city-based)
# -----------------------------
review_templates = [
  {
    title: "تجربة داخل المدينة ممتازة",
    rating: 5,
    body: "داخل المدينة الاستهلاك ممتاز والقيادة هادئة. الشحن بالبيت بيعتمد على ساعات الوصل، بس إذا بتقدر تشحن ببطء بالليل بتكون الأمور سهلة."
  },
  {
    title: "المدى على الأوتوستراد أقل من المتوقع",
    rating: 4,
    body: "تجربتي في %{city}: على الطرق السريعة المدى بينزل بشكل واضح، أما داخل المدينة أفضل. التكييف بالصيف بيأثر، فحاول تسوق بهدوء وتنتبه لضغط الإطارات."
  },
  {
    title: "اقتصادية مقارنة بالبنزين",
    rating: 5,
    body: "التكاليف اليومية أقل بكثير من البنزين إذا عندك خطة شحن ثابتة. الصيانة أخف. أهم شيء جودة التوصيل الكهربائي والأمان."
  },
  {
    title: "الشحن السريع مفيد عند الحاجة",
    rating: 4,
    body: "الشحن السريع ممتاز وقت الاستعجال أو قبل سفر، لكن للاستخدام اليومي الأفضل شحن بطيء حتى 80-90% للحفاظ على البطارية."
  },
  {
    title: "ممتعة بالقيادة لكن الطرق بتتعب",
    rating: 3,
    body: "بالـ%{city} الطرق والحفر بتخليك تنتبه كثير خصوصاً مع الإطارات العريضة. السيارة قوية بالعزم وممتعة، بس راقب الإطارات والجنوط بشكل دوري."
  },
  {
    title: "مناسبة للعائلة ومريحة",
    rating: 5,
    body: "السيارة مريحة للعائلة وهادئة بالزحمة. الفرملة الاسترجاعية بتخفف تعب القيادة. بس لازم يكون معك كابل/محوّل لأن المقابس بتختلف."
  }
]

target_reviews = 60
created_reviews = 0
attempts = 0

puts "Creating reviews..."
while created_reviews < target_reviews && attempts < 10_000
  attempts += 1

  u = users.sample
  next if u.admin?

  v = vehicles.sample
  next if Review.exists?(user: u, vehicle: v)

  tpl = review_templates.sample
  city_name_ar = city_ar(u.city)

  Review.create!(
    user: u,
    vehicle: v,
    rating: tpl[:rating],
    title: tpl[:title],
    body: with_city(tpl[:body], city_name_ar),
    status: :approved
  )

  created_reviews += 1
end

puts "Reviews created: #{created_reviews}"

# -----------------------------
# Questions + Answers (Arabic, city-based)
# -----------------------------
qa_templates = [
  {
    title: "حلول الشحن المنزلي مع ضعف الكهرباء؟",
    body: "شو حلول عملية للشحن بالبيت إذا الكهرباء ما بتجي بشكل ثابت؟ شو بتنصحوني من تجاربكن؟",
    answers: [
      "بالـ%{city} أفضل حل هو الشحن البطيء خلال ساعات الوصل، حتى لو ساعتين يومياً ممكن يكفوا حسب استخدامك. ركّب قاطع حماية وتأريض ممتاز.",
      "إذا متوفر عندك طاقة شمسية/بطاريات منزلية أو اشتراك مولدة، بتصير أسهل. الأهم ما تستخدم توصيلات عشوائية لأن الأمان الكهربائي أساسي."
    ]
  },
  {
    title: "هل الشحن السريع يضر البطارية على المدى الطويل؟",
    body: "عم استخدم شحن سريع أحياناً. هل التكرار بيأثر فعلاً على عمر البطارية؟",
    answers: [
      "مو ضرر مباشر، بس الأفضل تخليه للحاجة. إذا بتقدر تعتمد شحن بطيء بالبيت/العمل أغلب الوقت بيكون أفضل.",
      "حاول ما تشحن سريع من 0% لـ 100% دائماً. خلي الروتين 80-90%، و100% قبل سفر فقط."
    ]
  },
  {
    title: "المدى الحقيقي داخل المدينة مع التكييف؟",
    body: "قديش المدى الحقيقي تقريباً داخل المدينة؟ وهل التكييف بالصيف بيأثر كتير؟",
    answers: [
      "داخل المدينة غالباً أحسن من الطرق السريعة بسبب الفرملة الاسترجاعية. التكييف بيأثر، بس إذا بتسوق بهدوء بتلاحظ فرق جيد.",
      "راقب الاستهلاك (Wh/km) وخليه مؤشر. ارتفاع الاستهلاك ممكن يكون من ضغط الإطارات أو قيادة سريعة أو حرارة عالية."
    ]
  },
  {
    title: "نصائح لشراء سيارة كهربائية مستعملة بسوريا",
    body: "إذا بدي اشتري مستعملة، شو أهم شي لازم افحصه؟ وكيف أتأكد من صحة البطارية؟",
    answers: [
      "اطلب فحص صحة البطارية (SoH) إذا متوفر أو فحص عند مختص عبر OBD. وجرب مدى السيارة فعلياً بكذا مشوار.",
      "تأكد من تاريخ الحوادث والصيانة. وتجنب سيارات كانت تتشحن بسرعة بشكل دائم أو كانت مركونة فترة طويلة على شحن عالي."
    ]
  }
]

puts "Creating questions + answers..."
created_questions = 0
created_answers = 0

# 3 questions per city => 12
CITIES.each do |city|
  city_users = users.select { |u| u.city == city }
  next if city_users.empty?

  qa_templates.sample(3).each do |tpl|
    author = city_users.sample
    city_name_ar = city_ar(city)

    title = "[#{city_name_ar}] #{tpl[:title]}"
    q = Question.find_or_initialize_by(title: title)

    if q.new_record?
      q.user = author
      q.body = tpl[:body]
      q.status = :published
      q.save!
      created_questions += 1
    end

    tpl[:answers].each do |ans|
      answer_text = with_city(ans, city_name_ar)
      next if q.answers.exists?(body: answer_text)

      answer_user = (users - [author]).sample
      next if answer_user.admin?

      q.answers.create!(user: answer_user, body: answer_text)
      created_answers += 1
    end
  end
end

puts "Questions created: #{created_questions}"
puts "Answers created: #{created_answers}"


user1 = User.find_or_create_by!(email: "user@example.com") do |user|
  user.username = "user"
  user.password = "password123456"
  user.password_confirmation = "password123456"
  user.verified = true
end

# Attach avatar to user1 if not already attached
unless user1.avatar.attached?
  user1.avatar.attach(
    io: File.open(Rails.root.join("spec", "fixtures", "files", "test_image.png")),
    filename: "test_image.png",
    content_type: "image/png"
  )
end

puts "Created user:"
puts "  - user@example.com (username: user, password: password123456) - with avatar"

puts "== Done =="

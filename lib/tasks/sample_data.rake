namespace :db do
	desc "Populate the database with sample data"
	task populate: :environment do
		User.create!(name: "John Howlett",
			         email: "jhowlett4@example.com",
			         password: "password",
			         password_confirmation: "password",
			         admin: true)
		99.times do |n|
			name = Faker::Name.name
			email = "user-#{n+1}@example.com"
			User.create!(name: name,
				         email: email,
				         password: "password",
				         password_confirmation: "password")
		end
		users = User.all(limit: 6)
		50.times do
			content = Faker::Lorem.sentence(5)
			users.each { |user| user.microposts.create!(content: content) }
		end
	end
end
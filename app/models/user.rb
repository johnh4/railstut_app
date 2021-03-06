class User < ActiveRecord::Base
	has_many :microposts
	before_save { self.email = email.downcase }
	validates :name, presence: true, length: { maximum: 50 }
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	validates :email, presence: true, format: { with: VALID_EMAIL_REGEX },
	                  uniqueness: { case_sensitive: true }
	validates :password, length: { minimum: 6 } 
	has_secure_password

	has_many :relationships, foreign_key: "follower_id", dependent: :destroy
	has_many :followed_users, through: :relationships, source: :followed
	has_many :reverse_relationships, foreign_key: "followed_id", class_name: "Relationship",
	                                 dependent: :destroy
	has_many :followers, through: :reverse_relationships	                             

	before_create :create_remember_token

	def User.new_remember_token
		SecureRandom.urlsafe_base64
	end

	def User.encrypt(token)
		Digest::SHA1.hexdigest(token.to_s)
	end

	def feed
		Micropost.from_users_followed_by(self)
	end

	def following?(user)
		relationships.find_by(followed_id: user.id)
	end

	def follow!(user)
		relationships.create!(followed_id: user.id)
	end

	def unfollow!(user)
		relationships.find_by(followed_id: user.id).destroy!
	end

	private

		def create_remember_token
			self.remember_token = User.encrypt(User.new_remember_token)
		end
end

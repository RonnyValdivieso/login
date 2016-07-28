class User < ActiveRecord::Base
	# Include default devise modules. Others available are:
	# :confirmable, :lockable, :timeoutable and :omniauthable
	devise :database_authenticatable, :registerable, :omniauthable, :recoverable, :rememberable, :trackable

	belongs_to :role

	has_many :identities, dependent: :destroy
	has_many :active_relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
	has_many :passive_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
	has_many :following, through: :active_relationships, source: :followed
	has_many :followers, through: :passive_relationships, source: :follower

	has_many :posts, dependent: :destroy
	accepts_nested_attributes_for :posts

	def facebook
		identities.where( provider: "facebook" ).first
	end

	# Seguir a otro usuario
	def follow(other)
		active_relationships.create(followed_id: other.id)
	end

	# Dejar de seguir a otro usuario
	def unfollow(other)
		active_relationships.find_by(followed_id: other.id).destroy
	end

	# Verificar seguimiento
	def following?(other)
		following.include?(other)
	end


	private

	def set_default_role
		self.role ||= Role.find_by_name("fan")
	end
end

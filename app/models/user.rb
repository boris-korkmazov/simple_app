class User < ActiveRecord::Base

  has_many :microposts, dependent: :destroy

  has_many :relationships, foreign_key: "follower_id", dependent: :destroy

  has_many :followed_users, through: :relationships, source: :followed

  has_many :reverse_relationships, foreign_key: "followed_id", dependent: :destroy, class_name: "Relationship"

  has_many :followers, through: :reverse_relationships #, source: :follower

  validates :name, presence: true, length: { maximum:50 }
  VALID_EMAIL_REGEX = /\A[\w\+\-\.]+@[a-z\d\-\.]+\.[a-z]+\z/i
  validates :email, presence: true, 
                    length: {maximum: 50}, 
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }


  before_save { self.email = email.downcase}

  before_create :create_remember_token

  validates :password, length: { minimum: 6 }
  validates :password_confirmation, length: {minimum: 6}
  has_secure_password

  class << self
    def new_remember_token
      SecureRandom.urlsafe_base64
    end

    def encrypt(token)
      Digest::SHA1.hexdigest(token.to_s)
    end
  end

  def feed
    Micropost.from_users_followed_by(self)
  end

  def follow!(other_user)
    relationships.create!(followed_id: other_user.id)
  end

  def following?(other_user)
    relationships.find_by(followed_id: other_user.id)
  end

  def unfollow!(other_user)
    relationships.find_by(followed_id: other_user.id).destroy!
  end

  private

    def create_remember_token
      #Create token
      self.remember_token = User.encrypt(User.new_remember_token)
    end
end

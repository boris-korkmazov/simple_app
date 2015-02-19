class User < ActiveRecord::Base

  has_many :microposts, dependent: :destroy

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
    Micropost.where("user_id = ?", id)
  end

  private

    def create_remember_token
      #Create token
      self.remember_token = User.encrypt(User.new_remember_token)
    end
end

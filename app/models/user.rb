class User < ApplicationRecord
  # { self.email = self.email.downcase }の省略形
  # before_save { self.email = email.downcase }
  before_save { email.downcase! }
  # 下記でもコールバックをかける（「!」は破壊的メソッドになる）
  validates :name, presence:true, length: { maximum: 50 }

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence:true, length: { maximum: 255 }, format: { with: VALID_EMAIL_REGEX}, uniqueness: { case_sensitive: false }

  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }

  def self.digest(password)
    const = ActiveModel::SeurePassword.min_const ? BCrypt::Engine::MIN_COST : BCrypt::Enginge.cost
    BCrypt::Password.create(password, cost: cost)
  end
end

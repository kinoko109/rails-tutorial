class User < ApplicationRecord
  attr_accessor :remember_token

  # { self.email = self.email.downcase }の省略形
  # before_save { self.email = email.downcase }
  before_save { email.downcase! }
  # 下記でもコールバックをかける（「!」は破壊的メソッドになる）
  validates :name, presence:true, length: { maximum: 50 }

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence:true, length: { maximum: 255 }, format: { with: VALID_EMAIL_REGEX}, uniqueness: { case_sensitive: false }

  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true

  def self.digest(password)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create(password, cost: cost)
  end

  # ランダムトークン生成
  def self.new_token
    SecureRandom.urlsafe_base64
  end

  # 永続セッションのためにユーザーをデータベースに記憶する
  def remember
    self.remember_token = User.new_token
    # update_attributeメソッドはRailsのビルトインでバリデーションを行わずにDBデータを更新できる
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  def authenticated?(remember_digest)
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  def forget
    update_attribute(:remember_digest, nil)
  end

  private

    def downcase_email
      self.email = email.downcase
    end

    def create_activation_digest
      # 有効化トークンとダイジェストを作成および代入
      self.activation_token = User.new_token
      self.activation_digest = User.digest(activation_token)
    end
end

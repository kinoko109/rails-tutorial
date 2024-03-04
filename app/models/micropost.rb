class Micropost < ApplicationRecord
  belongs_to :user
  # -> という文法はラムダ式の書き方。Proc,lambdaオブジェクトを作成する。
  default_scope -> { order(created_at: :desc) }
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
end

class Message < ActiveRecord::Base
    
  belongs_to :user, foreign_key: "user_id"
  validates :user_id, presence: true
  # 広告種別は必須入力かつ30文字以内
  validates :media , length: { maximum: 30 } , presence: true
  # 媒体は必須入力かつ30文字以内
  validates :media , length: { maximum: 30 } , presence: true
  # リンク先URLは必須入力
  validates :rink , presence: true
end

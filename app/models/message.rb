class Message < ActiveRecord::Base
  belongs_to :user
  validates :user_id, presence: true

  # 媒体は必須入力
  validates :media , presence: true
  # リンク先URLは必須入力
  validates :rink , presence: true
end

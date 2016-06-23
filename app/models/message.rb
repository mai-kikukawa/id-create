class Message < ActiveRecord::Base
  has_many :messages
  belongs_to :user
  validates :user_id, presence: true

  # 媒体は必須入力
  validates :media , presence: true
  # リンク先URLは必須入力
  validates :rink , presence: true
  
  def self.to_csv
    CSV.generate do |csv|
      # column_namesはカラム名を配列で返す
      # 例: ["id", "name", "price", "released_on", ...]
      csv << csv_column_names
      all.each do |message|
        # attributes はカラム名と値のハッシュを返す
        # 例: {"id"=>1, "name"=>"レコーダー", "price"=>3000, ... }
        # valudes_at はハッシュから引数で指定したキーに対応する値を取り出し、配列にして返す
        # 下の行は最終的に column_namesで指定したvalue値の配列を返す
        csv << message.csv_column_values
      end
    end
  end
  
  def self.csv_column_names
    ["ID", "広告種別", "媒体種別", "出稿開始日", "出稿終了日","リンク先URL","生成URL","発行ID"]
  end
  
  def self.to_csv(options = {})
    CSV.generate(options) do |csv|
      csv << csv_column_names
      all.each do |message|
        csv << message.csv_column_values
      end
    end
  end

  def csv_column_values
    [id, tipe, media, start, finish, rink, createdurl, createdid]
  end
  
end

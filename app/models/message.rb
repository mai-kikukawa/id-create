class Message < ActiveRecord::Base
  has_many :messages
  belongs_to :user
  validates :user_id, presence: true
  # 媒体は必須入力
  validates :media , presence: true
  # リンク先URLは必須入力
  validates :rink , presence: true, format: /\A#{URI::regexp(%w(http https))}\z/
  # 日付のバリデーション。手抜きなので、不具合があったら外す。
  validates :start, :finish, allow_blank: true, 
            format: { with: /\A20\d{2}-((02\/[0-2]\d)|((0(2|4|6|9))|(11))-(([0-2]\d)|(30))|((0(1|3|5|7|8))|(1(0|2)))-(([0-2]\d)|(3[0-1])))\z/,
            message: "の日付は半角で[****-**-**]の形式で入力して下さい" }
  
  #def self.to_csv
    #CSV.generate do |csv|
      # column_namesはカラム名を配列で返す
      # 例: ["id", "name", "price", "released_on", ...]
      #csv << csv_column_names
      #all.each do |message|
        # attributes はカラム名と値のハッシュを返す
        # 例: {"id"=>1, "name"=>"レコーダー", "price"=>3000, ... }
        # valudes_at はハッシュから引数で指定したキーに対応する値を取り出し、配列にして返す
        # 下の行は最終的に column_namesで指定したvalue値の配列を返す
        #csv << message.csv_column_values
      #end
    #end
  #end
  
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
  
  #def self.import(file)   
   # spreadsheet = open_spreadsheet(file)
    #header = spreadsheet.row(1)

    #(2..spreadsheet.last_row).each do |i|
       # {カラム名 => 値, ...} のハッシュを作成する
      #row = Hash[[header, spreadsheet.row(i)].transpose]

      # IDが見つかれば、レコードを呼び出し、見つかれなければ、新しく作成
      #message = find_by(id: row["id"]) || new
      # CSVからデータを取得し、設定する
      #message.attributes = row.to_hash.slice(*updatable_attributes)
      # 保存する
      #message.save!
    #end
  #end

  def self.open_spreadsheet(file)
    case File.extname(file.original_filename)
    when '.csv'  then Roo::Csv.new(file.path,    nil, :ignore)
    when '.xls'  then Roo::Excel.new(file.path,  nil, :ignore)
    when '.xlsx' then Roo::Excelx.new(file.path, nil, :ignore)
    when '.ods'  then Roo::OpenOffice.new(file.path, nil, :ignore)
    else raise "Unknown file type: #{file.original_filename}"
    end
  end

  # 更新を許可するカラムを定義
  def self.updatable_attributes
    ["tipe", "media", "start", "finish", "rink"]
  end
  
        # CSVファイルの内容をDBに登録する
  def self.import(file)
    imported_num = 0
    # 文字コード変換のためにKernel#openとCSV#newを併用。
    # 参考: http://qiita.com/labocho/items/8559576b71642b79df67
    open(file.path, 'r:cp932:utf-8', undef: :replace) do |f|
      csv = CSV.new(f, :headers => :first_row)
      logger.debug f
      csv.each do |row|
        next if row.header_row?

        # CSVの行情報をHASHに変換
        table = Hash[[row.headers, row.fields].transpose]
       # 登録済みユーザー情報取得。
        # 登録されてなければ作成
        message = find_by(:id => table["id"])
        if message.nil?
          message = new
        end

        # ユーザー情報更新
        message.attributes = table.to_hash.slice(
                            *table.to_hash.except(:id, :created_at, :updated_at).keys)
        
        if message.media == 'Yahoo'
          @extention = "yho_"
        elsif message.media == 'google'
          @extention = "gle_"
        elsif message.media == 'rakuten'
          @extention = "rku_"
        elsif message.media == 'Amazon'
          @extention = "ama_"
        else
          @extention = "_error_"
        end
        
        media_id = (Message.last.id += 1).to_s
        message.createdurl = message.rink + '?banner_id=' + @extention + media_id.to_s
        message.createdid = @extention + media_id
        #やりたい処理（現在エラーになる）
        #message.user_id = current_user.id
        #message.createdurl = set_url(message)
        #message.createdid = publish_id(message)

        #実験用データー（生で入るか実験する）        
        #message.user_id = 7
        #message.createdurl = "yahoo.co.jp?ama_1"
        #message.createdid = "ama_1"

        # バリデーションOKの場合は保存
        if message.valid?
          message.save!
          imported_num += 1
        end
      end
    end
    # 更新件数を返却
    imported_num
  end
end

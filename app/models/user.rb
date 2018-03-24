class User < ApplicationRecord
  before_save { self.email.downcase! }
  validates :name, presence: true, length: { maximum: 50 }
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i },
                    uniqueness: { case_sensitive: false }
  has_secure_password

  has_many :microposts
  has_many :relationships
  has_many :followings, through: :relationships, source: :follow
  has_many :reverses_of_relationship, class_name: 'Relationship', foreign_key: 'follow_id'
  has_many :followers, through: :reverses_of_relationship, source: :user
  
  has_many :okiniiris #kadai2 中間テーブルで|user_id|micropost_id|
  has_many :get_okini_microposts, through: :okiniiris, source: :micropost #中間テーブルを通してその先のmicropost達のインスタンスをゲット

  def follow(other_user)
    unless self == other_user
      self.relationships.find_or_create_by(follow_id: other_user.id)
    end
  end

  def unfollow(other_user)
    relationship = self.relationships.find_by(follow_id: other_user.id)
    relationship.destroy if relationship
  end

  def following?(other_user)
    self.followings.include?(other_user)
  end
  
  #タイムライン用の混在マイクロポスト取得メソッド
  def feed_microposts
    puts '◆feed_microposts'
    puts self.following_ids
    puts '■■■■■'
    puts [self.id]
    puts '▲▲▲▲▲'
    Micropost.where(user_id: self.following_ids + [self.id]) #idsはfollowingユーザーのidの配列
  end
  
  #マイクロポストをお気に入りに登録
  def okini_toroku(micropost_id)
    self.okiniiris.find_or_create_by(micropost_id: micropost_id)
  end
  
  #マイクロポストをお気に入りから外す
  def okini_hazusi(micropost_id)
    aru = self.okiniiris.find_by(micropost_id: micropost_id)
    puts 'aru?'
    puts aru
    aru.destroy if aru
  end
  
  #すでにお気に入り済かをチェック
  def mou_okini?(micropost)
    self.get_okini_microposts.include?(micropost) #micropost_idじゃなくmicropostオブジェクト
  end  
  
end
class User < ActiveRecord::Base
  has_many :log_books, dependent: :destroy
  has_many :shares
  has_many :shared_log_books, through: :shares
  has_many :sections, through: :log_books
  has_many :section_properties, through: :sections
  has_many :world_objects, through: :log_books
  
  validates :uid, :uniqueness => {:scope => :provider}
  
  def self.create_with_omniauth(auth)
    create! do |user|
      user.provider = auth["provider"]
      user.uid = auth["uid"].to_s
      
      case user.provider
      when "google_oauth2"
        user.name = auth[:info][:email]
        user.nickname = auth[:info][:email]
      when "twitter"
        user.name     = auth["info"]["name"]
        user.nickname = auth["info"]["nickname"]
      when "facebook"
        user.name     = auth["info"]["name"]
        user.nickname = auth["info"]["nickname"]
      end
    end
  end
end
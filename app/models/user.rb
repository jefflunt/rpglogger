class User < ActiveRecord::Base
  has_many :log_books, :dependent => :destroy
  
  validates :uid, :uniqueness => {:scope => :provider}
  
  def self.create_with_omniauth(auth)
    create! do |user|
      user.provider = auth["provider"]
      user.uid = auth["uid"]
      
      case user.provider
      when "twitter"
        user.name     = auth["user_info"]["name"]
        user.nickname = auth["user_info"]["nickname"]
      when "facebook"
        user.name     = auth["info"]["name"]
        user.nickname = auth["info"]["nickname"]
      end
    end
  end
end
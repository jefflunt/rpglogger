class User < ActiveRecord::Base
  has_many :log_books, dependent: :destroy
  has_many :shares, dependent: :destroy
  has_many :shared_log_books, through: :shares
  
  validates :uid, :uniqueness => {:scope => :provider}
  
  def owned_and_shared_log_books(show_archived=false)
    # Gets a list of all LogBooks that this user has access to (both owned, and shared from other users), ordered by the title, case INsensitive.
    if show_archived
      LogBook.select("DISTINCT ON (LOWER(log_books.title), log_books.id) log_books.id, log_books.user_id, log_books.title, log_books.game_name, log_books.archived_at").joins("LEFT OUTER JOIN shares ON log_books.id = shares.log_book_id").where(["log_books.user_id = ? OR shares.user_id = ?", id, id]).order("LOWER(log_books.title) ASC")
    else
      LogBook.active.select("DISTINCT ON (LOWER(log_books.title), log_books.id) log_books.id, log_books.user_id, log_books.title, log_books.game_name, log_books.archived_at").joins("LEFT OUTER JOIN shares ON log_books.id = shares.log_book_id").where(["log_books.user_id = ? OR shares.user_id = ?", id, id]).order("LOWER(log_books.title) ASC")
    end
  end
  
  def can_view_world_objects_in?(log_book)
    share_on_log_book = shares.find_by_log_book_id(log_book.id)
    role_on_log_book = share_on_log_book.nil? ? nil : share_on_log_book.role
    log_book.is_public? || log_book.owned_by?(self) || role_on_log_book == "viewer" || role_on_log_book == "editor"
  end
  
  def can_manage_world_objects_in?(log_book)
    share_on_log_book = shares.find_by_log_book_id(log_book.id)
    role_on_log_book = share_on_log_book.nil? ? nil : share_on_log_book.role
    log_book.owned_by?(self) || role_on_log_book == "editor"
  end
  
  def can_fully_manage?(log_book)
    log_book.owned_by?(self)
  end
    
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
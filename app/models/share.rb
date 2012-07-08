class Share < ActiveRecord::Base
  belongs_to :shared_user, class_name: "User", foreign_key: "user_id"
  belongs_to :shared_log_book, class_name: "LogBook", foreign_key: "log_book_id"
  
  attr_protected :log_book_id, :user_id, :access_level
end
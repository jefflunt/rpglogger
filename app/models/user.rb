class User < ActiveRecord::Base
  acts_as_authentic
  
  has_many :log_books, :dependent => :destroy
end
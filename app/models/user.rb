class User < ActiveRecord::Base
  acts_as_authentic
  
  has_many :log_books, :dependent => :destroy
  
  validate :login, :presence => true
  validate :crypted_password, :presence => true
end
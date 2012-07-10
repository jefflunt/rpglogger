class Ability
  include CanCan::Ability

  def initialize(user, params=nil)
    user ||= User.new
    
    can :index, LogBook
    
    can [:index, :show], LogBook do |log_book|
      user.can_read_from?(log_book)
    end
    
    unless user.new_record?
      can [:edit, :update], LogBook do |log_book|
        user.can_write_to?(log_book)
      end
      
      can :manage, LogBook do |log_book|
        log_book.owned_by?(user)
      end
    end
  end
end

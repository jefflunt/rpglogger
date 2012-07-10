class Ability
  include CanCan::Ability

  def initialize(user, params=nil)
    user ||= User.new
    
    can :read, LogBook do |log_book|
      user.can_read_from?(log_book) # log_book.is_public? || log_book.shared_users.include?(user)
    end
    
    can :read, Section do |section|
      user.can_read_from?(section.log_book) # section.log_book.is_public? || section.log_book.shared_users.include?(user)
    end
    
    unless user.new_record?
      can :manage, LogBook do |log_book|
        user.can_write_to?(log_book)
      end
    
      can :manage, Section do |section|
        user.can_write_to?(section.log_book)
      end
    
      can :manage, WorldObject do |world_object|
        user.can_write_to?(world_object.section.log_book)
      end
    
      can :manage, SectionProperty do |section_property|
        user.can_write_to?(section_property.section.log_book)
      end
    end
  end
end

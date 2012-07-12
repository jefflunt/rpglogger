class Ability
  include CanCan::Ability

  def initialize(user, params=nil)
    user ||= User.new
    
    can :index, LogBook
    
    can :show, LogBook do |log_book|
      user.can_view_world_objects_in?(log_book)
    end
    
    unless user.new_record?
      can [:new], LogBook
      
      can :manage, LogBook do |log_book|
        log_book.owned_by?(user)
      end
      
      can :manage, WorldObject do |world_object|
        user.can_edit_world_objects_in?(world_object.section.log_book)
      end
    end
  end
end

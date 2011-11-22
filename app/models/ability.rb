class Ability
  include CanCan::Ability

  # Wiki for details: https://github.com/ryanb/cancan/wiki/Defining-Abilities
  def initialize(user)
    user ||= User.new
    
    can :manage, LogBook, :user_id => user.id
    
    can :manage, Section do |section|
      user.sections.include?(section)
    end
    
    can :manage, WorldObject do |world_object|
      user.world_objects.include?(world_object) || world_object.new_record?
    end
    
    can :manage, SectionProperty do |section_property|
      user.section_properties.include?(section_property)
    end
  end
end

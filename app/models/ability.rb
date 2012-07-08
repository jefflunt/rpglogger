class Ability
  include CanCan::Ability

  def initialize(user, params=nil)
    user ||= User.new
    
    can :read, LogBook, :is_public? => true
    can :read, Section, :is_public? => true
    
    unless user.new_record?
      can :manage, LogBook, :user_id => user.id
    
      can :manage, Section do |section|
        user.sections.include?(section)
      end
    
      can :manage, WorldObject do |world_object|
        user.world_objects.include?(world_object) || user.sections.include?(Section.find(params[:section_id]))
      end
    
      can :manage, SectionProperty do |section_property|
        user.section_properties.include?(section_property)
      end
    end
  end
end

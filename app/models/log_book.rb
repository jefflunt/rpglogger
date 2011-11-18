class LogBook < ActiveRecord::Base
  belongs_to :user
  belongs_to :game
  
  has_many :sections, :dependent => :destroy
  has_many :world_objects, :through => :sections, :dependent => :destroy
  
  validate :title, :presence => true
  
  accepts_nested_attributes_for :sections
  
  def create_default_sections
    locations_section  = Section.create(:log_book_id => self.id, :name => 'locations')
  
    quests_section  = Section.create(:log_book_id => self.id, :name => 'quests')
    quest_detail    = SectionProperty.create(:section => quests_section, :name => 'detail',     :data_type => 'text',    :sort_order => 1)
    quest_completed = SectionProperty.create(:section => quests_section, :name => 'completed?', :data_type => 'boolean', :sort_order => 2)
    
    journal_section = Section.create(:log_book_id => self.id, :name => 'journal')
    jounral_entry   = SectionProperty.create(:section => journal_section, :name => 'entry', :data_type => 'text',   :sort_order => 1)
  
    characters_section = Section.create(:log_book_id => self.id, :name => 'characters')
    character_level = SectionProperty.create(:section => characters_section, :name => 'level',      :data_type => 'integer', :sort_order => 1)
    character_story = SectionProperty.create(:section => characters_section, :name => 'back story', :data_type => 'text',    :sort_order => 2)
  end
end
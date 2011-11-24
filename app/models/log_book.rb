class LogBook < ActiveRecord::Base
  belongs_to :user
  belongs_to :game
  
  has_many :sections, :dependent => :destroy
  has_many :world_objects, :through => :sections
  
  validates :title, :presence => true
  
  accepts_nested_attributes_for :sections
  
  def sorted_sections
    sections.sort{|s1, s2| s1.name.downcase <=> s2.name.downcase}
  end
  
  def create_empty_section
    empty_section = Section.create(:log_book_id=>self.id, :name=>'New Section')
  end
  
  def create_default_sections
    locations_section  = Section.create(:log_book_id => self.id, :name => 'Locations')
  
    quests_section  = Section.create(:log_book_id => self.id, :name => 'Quests')
    quest_detail    = SectionProperty.create(:section => quests_section, :name => 'Detail',     :data_type => 'text',    :sort_order => 1)
    quest_completed = SectionProperty.create(:section => quests_section, :name => 'Completed?', :data_type => 'boolean', :sort_order => 2)
    
    journal_section = Section.create(:log_book_id => self.id, :name => 'Journal')
    jounral_entry   = SectionProperty.create(:section => journal_section, :name => 'Entry', :data_type => 'text',   :sort_order => 1)
  
    characters_section = Section.create(:log_book_id => self.id, :name => 'Characters')
    character_level = SectionProperty.create(:section => characters_section, :name => 'Level',      :data_type => 'integer', :sort_order => 1)
    character_story = SectionProperty.create(:section => characters_section, :name => 'Back Story', :data_type => 'text',    :sort_order => 2)
  end
end
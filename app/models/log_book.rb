class LogBook < ActiveRecord::Base
  belongs_to :user
  belongs_to :game
  
  has_many :shares, dependent: :destroy
  has_many :shared_users, through: :shares
  has_many :sections, order: :name, dependent: :destroy
  has_many :world_objects, through: :sections
  
  validates :title, :presence => true
  
  scope :public, where(["is_public = ?", true])
  scope :active, where("archived_at IS NULL")
  scope :archived, where("archived_at IS NOT NULL")
  
  accepts_nested_attributes_for :sections
  accepts_nested_attributes_for :shares
  
  def archived?
    archived_at != nil
  end
  
  def owned_by?(user)
    user_id == user.id
  end
    
  def create_empty_section
    empty_section = Section.create(log_book_id: self.id, name: 'New Section')
  end
  
  def create_default_sections
    locations_section  = Section.create(log_book_id: self.id, name: 'Locations')
  
    quests_section  = Section.create(log_book_id: self.id, name: 'Quests')
    quest_detail    = SectionProperty.create(section: quests_section, name: 'Detail',     data_type: 'text',    sort_order: 1)
    quest_completed = SectionProperty.create(section: quests_section, name: 'Completed?', data_type: 'boolean', sort_order: 2)
    
    journal_section = Section.create(log_book_id: self.id, name: 'Journal')
    jounral_entry   = SectionProperty.create(section: journal_section, name: 'Entry', data_type: 'text',   sort_order: 1)
  
    characters_section = Section.create(log_book_id: self.id, name: 'Characters')
    character_level = SectionProperty.create(section: characters_section, name: 'Level',      data_type: 'integer', sort_order: 1)
    character_story = SectionProperty.create(section: characters_section, name: 'Back Story', data_type: 'text',    sort_order: 2)
  end
end
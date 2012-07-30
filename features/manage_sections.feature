Feature: Manage Sections

Scenario: A user can access Sections that they own
  Given I am signed in with provider "facebook"
  And a LogBook exists called "Test LogBook" for game "Skyrim" and owned by "facebook_user"
  And a Section exists called "Test Section" in "Test LogBook"
  
  When I access the LogBook "Test LogBook"
  Then I should see the text "Test Section"
  
  When I access the Section "Test Section"
  Then I should see the text "Name/Title"
      
Scenario: A user cannot access Sections that they do not own
  Given I am signed in with provider "facebook"
  And a LogBook exists called "Test LogBook" for game "Skyrim" and owned by "facebook_user"
  And a Section exists called "Test Section" in "Test LogBook"
  
  When I access the LogBook "Test LogBook"
  Then I should see the text "Test Section"
  
  When I access the Section "Test Section"
  Then I should see the text "Name/Title"

Scenario: Access denied message appears for trying to access Sections you do not own
  Given I am signed in with provider "facebook"
  And a LogBook exists called "Someone else's LogBook" for game "Skyrim" and owned by "someoneelse"
  And a Section exists called "Someone else's Section" in "Someone else's LogBook"
  
  When I access the LogBook "Someone else's LogBook"
  Then I should see the text "You don't have access to that."
  
  When I access the Section "Someone else's Section"
  Then I should see the text "You don't have access to that."
  
Scenario: A user can edit SectionProperties on a Section that they own
  Given I am signed in with provider "facebook"
  And a LogBook exists called "Test LogBook" for game "Skyrim" and owned by "facebook_user"
  And a Section exists called "Test Section" in "Test LogBook"
  
  When I edit the Section "Test Section"
  Then I should see all of the texts:
    | Section Title                     |
    | Section Attributes                |
    | New Attributes (comma-separated)  |

Scenario: Access denied message appears for trying to edit SectionProperties on a Section you do not own
  Given I am signed in with provider "facebook"
  And a LogBook exists called "Someone else's LogBook" for game "Skyrim" and owned by "someoneelse"
  And a Section exists called "Someone else's Section" in "Someone else's LogBook"
  
  When I edit the LogBook "Someone else's LogBook"
  Then I should see the text "You don't have access to that."
  
  When I edit the Section "Someone else's Section"
  Then I should see the text "You don't have access to that."
  
Scenario: A user can create new Sections
  Given I am signed in with provider "facebook"
  And a LogBook exists called "Test LogBook" for game "Skyrim" and owned by "facebook_user"
  
  When I go to the edit LogBook page for "Test LogBook"
  And I fill in "sections[new_names]" with "new section 1, new section 2"
  And I press "Add sections"
  
  Then I should see all of the texts: 
    | editing Test LogBook  |
    | new section 1         |
    | new section 2         |
  
Scenario: When user adds new attributes to a Section, the existing WorldObjects get those attributes
  Given I am signed in with provider "facebook"
  And a LogBook exists called "Test LogBook" for game "Skyrim" and owned by "facebook_user"
  And a Section exists called "Test Section" in "Test LogBook"
  And a WorldObject exists called "Test WorldObject 1" in "Test Section"
  And a WorldObject exists called "Test WorldObject 2" in "Test Section"
  Then the total number of active SectionProperties should be 0
  And the total number of WorldObjectProperties should be 0
  And I should not see the text "Archive"
  
  When I go to the edit page for the first section in LogBook "Test LogBook"
  And I fill in "section_properties[new_section_property_names]" with "new attribute 1, new attribute 2"
  And I press "Update attributes"
  Then the total number of active SectionProperties should be 2
  And the total number of WorldObjectProperties should be 4
  And I should see all of the texts:
    | boolean |
    | Archive |
  
Scenario: When user removes exiting attributes from a Section, the WorldObjectProperties attaches to those SectionProperties are also removed (destroyed)
  Given I am signed in with provider "facebook"
  And a LogBook exists called "Test LogBook" for game "Skyrim" and owned by "facebook_user"
  And a Section exists called "Test Section" in "Test LogBook"
  And a WorldObject exists called "Test WorldObject 1" in "Test Section"
  And a WorldObject exists called "Test WorldObject 2" in "Test Section"

  When I go to the edit page for the first section in LogBook "Test LogBook"
  And I fill in "section_properties[new_section_property_names]" with "new attribute 1, new attribute 2"
  And I press "Update attributes"

  Then the total number of active SectionProperties should be 2
  
  When I follow "Archive"
  Then the total number of active SectionProperties should be 1

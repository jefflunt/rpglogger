Feature: Manage Sections

Scenario: A user can access Sections that they own
  Given I am signed in with "facebook"
  And a LogBook exists called "Test LogBook" for game "Skyrim" and owned by "fooman"
  And a Section exists called "Test Section" in "Test LogBook"
  
  When I access the LogBook "Test LogBook"
  Then I should see "Test Section"
  
  When I access the Section "Test Section"
  Then I should see "Name/Title"
      
Scenario: A user cannot access Sections that they do not own
  Given I am signed in with "facebook"
  And a LogBook exists called "Test LogBook" for game "Skyrim" and owned by "fooman"
  And a Section exists called "Test Section" in "Test LogBook"
  
  When I access the LogBook "Test LogBook"
  Then I should see "Test Section"
  
  When I access the Section "Test Section"
  Then I should see "Name/Title"

Scenario: Access denied message appears for trying to access Sections you do not own
  Given I am signed in with "facebook"
  And a LogBook exists called "Someone else's LogBook" for game "Skyrim" and owned by "someoneelse"
  And a Section exists called "Someone else's Section" in "Someone else's LogBook"
  
  When I access the LogBook "Someone else's LogBook"
  Then I should see "You don't have access to that."
  
  When I access the Section "Someone else's Section"
  Then I should see "You don't have access to that."
  
Scenario: A user can edit SectionProperties on a Section that they own
  Given I am signed in with "facebook"
  And a LogBook exists called "Test LogBook" for game "Skyrim" and owned by "fooman"
  And a Section exists called "Test Section" in "Test LogBook"
  
  When I edit the Section "Test Section"
  Then I should see "Section Title"
  And I should see "Section Attributes"
  And I should see "New Attributes (comma-separated)"

Scenario: Access denied message appears for trying to edit SectionProperties on a Section you do not own
  Given I am signed in with "facebook"
  And a LogBook exists called "Someone else's LogBook" for game "Skyrim" and owned by "someoneelse"
  And a Section exists called "Someone else's Section" in "Someone else's LogBook"
  
  When I edit the LogBook "Someone else's LogBook"
  Then I should see "You don't have access to that."
  
  When I edit the Section "Someone else's Section"
  Then I should see "You don't have access to that."
  
Scenario: A user can create new Sections
  Given pending
Feature: Manage LogBooks

Scenario: When a user with zero LogBooks logs in, they are taken to the new LogBook page
  Given I am signed in with "facebook"
  Then I should see "Log Book Title"
  And I should see "Choose Your Game"
  
Scenario: When a user with one or more Logbook logs in, they are taken to the LogBook index page
  Given a LogBook exists called "Test LogBook" for game "Skyrim" and owned by "fooman"
  Then the total number of LogBooks should be "1"
  
  Given I am signed in with "facebook"
  Then I should see "Your log books"

Scenario: A user can create a new LogBook
  Given I am signed in with "facebook"
  And a game exists called "Some game name"
  
  When I go to the new LogBooks page
  And I fill in "log_book[title]" with "My new LogBook"
  And I press "Create"
  
  Then I should see "SECTIONS (edit)"
  And the total number of Sections should be "4"

Scenario: A user can delete LogBooks they own, and all the Sections, SectionProperties, WorldObjects, and WorldObjectProperties go with it
  Given I am signed in with "facebook"
  And a LogBook exists called "Test LogBook" for game "Skyrim" and owned by "fooman"
  And a Section exists called "Test Section" in "Test LogBook"
  And a WorldObject exists called "Test WorldObject" in "Test Section"
  And a SectionProperty exists called "Section Attribute" in "Test Section"
  And a WorldObjectProperty exists that points to SectionProperty "Section Attribute" and WorldObject "Test WorldObject" with a value "false"
  
  When I go to the LogBooks index page
  Then I should see "Test LogBook"
  And the total number of LogBooks should be "1"
  And the total number of Sections should be "1"
  And the total number of WorldObjects should be "1"
  And the total number of WorldObjectProperties should be "1"
  
  When I go to the LogBooks index page
  And I follow "X"
  And I go to the LogBooks index page
  Then I should not see "Test LogBook"
  And the total number of LogBooks should be "0"
  And the total number of Sections should be "0"
  And the total number of WorldObjects should be "0"
  And the total number of WorldObjectProperties should be "0"
  
Scenario: A user cannot delete LogBooks they do not own
  Given I am signed in with "facebook"
  And a LogBook exists called "Someone else's LogBook" for game "Skyrim" and owned by "someoneelse"
  And a Section exists called "Someone else's Section" in "Someone else's LogBook"
  And a WorldObject exists called "Someone else's WorldObject" in "Someone else's Section"
  And a SectionProperty exists called "Someone else's Attribute" in "Someone else's Section"
  And a WorldObjectProperty exists that points to SectionProperty "Someone else's Attribute" and WorldObject "Someone else's WorldObject" with a value "false"
  
  When I go to the LogBooks index page
  Then I should not see "Someone else's LogBook"
  And the total number of LogBooks should be "1"
  And the total number of Sections should be "1"
  And the total number of WorldObjects should be "1"
  And the total number of WorldObjectProperties should be "1"
  
  When I try to manually destroy the LogBook "Someone else's LogBook"
  And the total number of LogBooks should be "1"
  And the total number of Sections should be "1"
  And the total number of WorldObjects should be "1"
  And the total number of WorldObjectProperties should be "1"

Scenario: A user can access LogBooks that they own
  Given I am signed in with "facebook"
  And a LogBook exists called "Test LogBook" for game "Skyrim" and owned by "fooman"
  
  When I go to the LogBooks index page
  Then I should see "Test LogBook"
  And I should see "Skyrim"
  And I should see "No. of Items"
  And I should see "0"
    
Scenario: A user cannot access LogBooks that they do not own
  Given I am signed in with "facebook"
  And a LogBook exists called "Someone else's log book" for game "Skyrim" and owned by "someoneelse"
  When I go to the LogBooks index page
  Then I should not see "Someone else's log book"
  
Scenario: Access denied message appears for trying to access LogBooks you do not own
  Given I am signed in with "facebook"
  And a LogBook exists called "Someone else's log book" for game "Skyrim" and owned by "someoneelse"
  When I access the LogBook "Someone else's log book"
  Then I should see "You don't have access to that."
  
Scenario: A user can edit Sections on a LogBook that they own
  Given I am signed in with "facebook"
  And a LogBook exists called "Test LogBook" for game "Skyrim" and owned by "fooman"
  When I edit the LogBook "Test LogBook"
  Then I should see "Log Book Title"
  And I should see "Sections"
  And I should see "New Sections (comma-separated)"

Scenario: Access denied message appears for trying to edit Sections on a LogBook you do not own
  Given I am signed in with "facebook"
  And a LogBook exists called "Someone else's log book" for game "Skyrim" and owned by "someoneelse"
  
  When I edit the LogBook "Someone else's log book"
  Then I should see "You don't have access to that."
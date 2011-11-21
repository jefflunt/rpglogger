Feature: Manage LogBooks

Scenario: A user can access LogBooks that they own
  Given I am signed in with "facebook"
  And a LogBook exists called "Test LogBook" for game "Skyrim" and owned by "fooman"
  When I go to "the LogBooks index"
  
  Then I should see "Test LogBook"
  And I should see "Skyrim"
  And I should see "No. of Items"
  And I should see "0"
    
Scenario: A user cannot access LogBooks that they do not own
  Given I am signed in with "facebook"
  And a LogBook exists called "Someone else's log book" for game "Skyrim" and owned by "someoneelse"
  When I go to "the LogBooks index"
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
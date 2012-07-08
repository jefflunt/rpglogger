Feature: Public sharing

Background:
  Given I am signed in with "facebook"
  And a LogBook exists called "Test LogBook" for game "Skyrim" and owned by "fooman"
  And a Section exists called "Test Section" in "Test LogBook"
  And a WorldObject exists called "Test WorldObject" in "Test Section"
  Then I sign out

Scenario: Anonymous users can see public LogBooks
  When the LogBook "Test LogBook" is marked as public
  And I go to the LogBooks index page
  Then I should see the text "Test LogBook"
  And I should not see the text "✖"

Scenario: Anonymous cannot see a LogBook in the public list that is not shared publicly
  When the LogBook "Test LogBook" is marked as private
  And I go to the LogBooks index page
  Then I should not see the text "Test LogBook"

Scenario: Anonymous users cannot view a LogBook that is not shared publicly
  When I go to the show LogBook page for "Test LogBook"
  Then I should see the text "You don't have access to that."

Scenario: Anonymous users cannot change nor delete a WorldObject
  Given pending

Scenario: Anonymous users cannot change nor delete a Section
  Given pending

Scenario: Anonymous users cannot change nor delete a LogBook
  Given pending
  
Scenario: Anonymouse users cannot change the permissions on a LogBook
  Given pending

Scenario: Registered users can see public LogBooks
  Given pending
  
Scenario: Registered users can see LogBooks that are shared with them
  Given pending

Scenario: Registered users cannot view a LogBook that is not shared with them
  Given pending
  
Scenario: Registered users cannot change nor delete a WorldObject in a LogBook with read-only access
  Given pending
  
Scenario: Registered users cannot change nor delete a Section in a LogBook with read-only access
  Given pending
  
Scenario: Registered users cannot change nor delete a LogBook with read-only access
  Given pending

Scenario: Registered users cannot change the permissions of a LogBook that they do not own
  Given pending

Scenario: Registered users CAN change permissions on LogBooks that they own
  Given pending
  
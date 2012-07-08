Feature: Public sharing

Background:
  Given I am signed in with "facebook"
  And a LogBook exists called "Test LogBook" for game "Skyrim" and owned by "fooman"
  And a Section exists called "Test Section" in "Test LogBook"
  And a WorldObject exists called "Test WorldObject" in "Test Section"
  And the LogBook "Test LogBook" is marked as public
  Then I sign out

Scenario: Anonymous users can see public LogBooks
  And I go to the LogBooks index page
  Then I should see the text "Test LogBook"
  And I should not see the text "✖"

Scenario: Anonymous cannot see a LogBook in the public list that is not shared publicly
  When the LogBook "Test LogBook" is marked as private
  And I go to the LogBooks index page
  Then I should not see the text "Test LogBook"

Scenario: Anonymous users cannot view a LogBook that is not shared publicly
  When the LogBook "Test LogBook" is marked as private
  And I go to the show LogBook page for "Test LogBook"
  Then I should see the text "You don't have access to that."

Scenario: Anonymous users cannot edit a WorldObject
  When I go to the edit WorldObject page for "Test WorldObject" in "Test Section" of "Test LogBook"
  Then I should see the text "You don't have access to that."
  
  When I try to change the name of WorldObject "Test WorldObject" in "Test Section" of "Test LogBook" to "Vandalised object"
  Then I should see the text "You don't have access to that."
  
Scenario: Anonymous users cannot delete a WorldObject
  Given the total number of WorldObjects should be 1
  When I try to delete the WorldObject "Test WorldObject" in "Test Section" of "Test LogBook"
  Then I should see the text "Signed out."
  And the total number of WorldObjects should be 1

Scenario: Anonymous users cannot edit a Section
  When I go to the edit page for the first section in LogBook "Test LogBook"
  Then I should see the text "You don't have access to that."
  
  When I try to change the name of Section "Test Section" of "Test LogBook" to "Vandalised section"
  Then I should see the text "You don't have access to that."

Scenario: Anonymous users cannot delete a Section
  Given the total number of Sections should be 1
  When I try to delete the Section "Test Section" of "Test LogBook"
  Then I should see the text "Signed out."
  And the total number of Sections should be 1

Scenario: Anonymous users cannot change a LogBook
  When I go to the edit LogBook page for "Test LogBook"
  Then I should see the text "You don't have access to that."

  When I try to change the name of LogBook "Test LogBook" to "Vandalised log book"
  Then I should see the text "You don't have access to that."

Scenario: Anonymous users cannot delete a LogBook
  Given the total number of LogBooks should be 1
  When I try to delete the LogBook "Test LogBook"
  Then I should see the text "Signed out."
  And the total number of LogBooks should be 1
  
Scenario: Anonymous users cannot change the list of users that have access to a LogBook
  Given pending

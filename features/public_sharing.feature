Feature: Public sharing with an anonymous user

Background:
  Given I am signed in with "facebook"
  And a LogBook exists called "Public LogBook" for game "Skyrim" and owned by "facebook_user"
  And a Section exists called "Public Section" in "Public LogBook"
  And a WorldObject exists called "Public WorldObject" in "Public Section"
  And the LogBook "Public LogBook" is marked as public
  Then I sign out

Scenario: Anonymous users can see public LogBooks
  When I go to the LogBooks index page
  Then I should see the text "Public LogBook"
  And I should not see the text "✖"

Scenario: Anonymous cannot see a LogBook in the public list that is not shared publicly
  When the LogBook "Public LogBook" is marked as private
  And I go to the LogBooks index page
  Then I should not see the text "Public LogBook"

Scenario: Anonymous users cannot view a LogBook that is not shared publicly
  When the LogBook "Public LogBook" is marked as private
  And I go to the show LogBook page for "Public LogBook"
  Then I should see the text "You don't have access to that."

Scenario: Anonymous users cannot edit a WorldObject
  When I go to the edit WorldObject page for "Public WorldObject" in "Public Section" of "Public LogBook"
  Then I should see the text "You don't have access to that."
  
  When I try to change the name of WorldObject "Public WorldObject" in "Public Section" of "Public LogBook" to "Vandalised object"
  Then I should see the text "You don't have access to that."
  
Scenario: Anonymous users cannot delete a WorldObject
  Given the total number of WorldObjects should be 1
  When I try to delete the WorldObject "Public WorldObject" in "Public Section" of "Public LogBook"
  Then I should see the text "Signed out."
  And the total number of WorldObjects should be 1

Scenario: Anonymous users cannot edit a Section
  When I go to the edit page for the first section in LogBook "Public LogBook"
  Then I should see the text "You don't have access to that."
  
  When I try to change the name of Section "Public Section" of "Public LogBook" to "Vandalised section"
  Then I should see the text "You don't have access to that."

Scenario: Anonymous users cannot delete a Section
  Given the total number of Sections should be 1
  When I try to delete the Section "Public Section" of "Public LogBook"
  Then I should see the text "Signed out."
  And the total number of Sections should be 1

Scenario: Anonymous users cannot change a LogBook
  When I go to the edit LogBook page for "Public LogBook"
  Then I should see the text "You don't have access to that."

  When I try to change the name of LogBook "Public LogBook" to "Vandalised log book"
  Then I should see the text "You don't have access to that."

Scenario: Anonymous users cannot delete a LogBook
  Given the total number of LogBooks should be 1
  When I try to delete the LogBook "Public LogBook"
  Then I should see the text "Signed out."
  And the total number of LogBooks should be 1
  
Scenario: Anonymous users cannot change the list of users that have access to a LogBook
  Given pending

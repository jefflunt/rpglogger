Feature: Private sharing between a facebook and google user

Background:
  Given a user named "google_user" with provider "google_oauth2" and uid "1234" exists
  Given a user named "facebook_user" with provider "facebook" and uid "1234" exists
  
  Given a LogBook exists called "Private LogBook" for game "Skyrim" and owned by "facebook_user"
  Given a Section exists called "Private Section" in "Private LogBook"
  Given a WorldObject exists called "Private WorldObject" in "Private Section"
  Given the LogBook "Private LogBook" is marked as private
  
  Given a LogBook exists called "Shared LogBook" for game "Skyrim" and owned by "facebook_user"
  Given a Section exists called "Shared Section" in "Shared LogBook"
  Given a WorldObject exists called "Shared WorldObject" in "Shared Section"
  Given the LogBook "Shared LogBook" is marked as private
  Given the LogBook "Shared LogBook" is shared with "google_user"
  
  Given a LogBook exists called "Public LogBook" for game "Skyrim" and owned by "facebook_user"
  Given a Section exists called "Public Section" in "Public LogBook"
  Given a WorldObject exists called "Public WorldObject" in "Public Section"
  Given the LogBook "Public LogBook" is marked as public
  
  Given I am signed in with "google_oauth2"
  
Scenario: Registered users can see public LogBooks
  When I go to the LogBooks index page
  Then I should see the text "Public LogBook"
  And I should not see the text "✖"
  
Scenario: Registered users can see LogBooks that are shared with them
  Given the number of LogBooks shared with "google_user" is 1
  When I go to the LogBooks index page
  Then I should see the text "Shared LogBook"
  And I should see the text "⥮"
  And I should not see the text "✖"  

Scenario: Registered users cannot view a LogBook that is not shared with them
  When I go to the LogBooks index page
  Then I should not see the text "Private LogBook"
  And I should not see the text "✖"
  
Scenario: Registered users cannot edit a WorldObject in a LogBook with read-only access
  When I go to the edit WorldObject page for "Shared WorldObject" in "Shared Section" of "Shared LogBook"
  Then I should see the text "You don't have access to that."
  
  When I try to change the name of WorldObject "Shared WorldObject" in "Shared Section" of "Shared LogBook" to "Vandalised object"
  Then I should see the text "You don't have access to that."  

Scenario: Registered users cannot delete a WorldObject in a LogBook with read-only access
  Given the total number of WorldObjects should be 3
  When I try to delete the WorldObject "Shared WorldObject" in "Shared Section" of "Shared LogBook"
  Then I should see the text "Signed in."
  And the total number of WorldObjects should be 3
  
Scenario: Registered users cannot edit a Section in a LogBook with read-only access
  When I go to the edit page for the first section in LogBook "Shared LogBook"
  Then I should see the text "You don't have access to that."
  
  When I try to change the name of Section "Shared Section" of "Shared LogBook" to "Vandalised section"
  Then I should see the text "You don't have access to that."

Scenario: Registered users cannot delete a Section in a LogBook with read-only access
  Given the total number of Sections should be 3
  When I try to delete the Section "Shared Section" of "Shared LogBook"
  Then I should see the text "Signed in."
  And the total number of Sections should be 3
  
Scenario: Registered users change edit a LogBook with read-only access
  When I go to the edit LogBook page for "Shared LogBook"
  Then I should see the text "You don't have access to that."

  When I try to change the name of LogBook "Shared LogBook" to "Vandalised log book"
  Then I should see the text "You don't have access to that."

Scenario: Registered users cannot delete a LogBook with read-only access
  Given the total number of LogBooks should be 3
  When I try to delete the LogBook "Shared LogBook"
  Then I should see the text "Signed in."
  And the total number of LogBooks should be 3

Scenario: Registered users CANNOT edit the list of users on LogBooks to which they have read-only access
  Given the number of users who have shared access to "Shared LogBook" should be 1
  When I try to change the access list of LogBook "Shared LogBook" to add "google_user"
  Then I should see the text "Signed in."
  And the number of users who have shared access to "Shared LogBook" should be 1

Scenario: Registered users CANNOT edit the list of users on LogBooks to which they have read-wright access
  Given pending

Scenario: Registered users CAN view LogBooks AND Sections (containing lists of WorldObjects) on LogBooks that are shared with read-only access to them
  Given pending
  
Scenario: Registered users CAN edit AND delete WorldObjects on LogBook that are shared with read-write access to them
  Given pending
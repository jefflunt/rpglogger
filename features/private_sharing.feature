Feature: Private sharing between a facebook and google user

Background:
  Given a user named "google_user" with provider "google_oauth2" and uid "1234" exists
  Given a user named "facebook_user" with provider "facebook" and uid "1234" exists
  
  Given a LogBook exists called "Test LogBook" for game "Skyrim" and owned by "facebook_user"
  Given a Section exists called "Test Section" in "Test LogBook"
  Given a WorldObject exists called "Test WorldObject" in "Test Section"
  Given the LogBook "Test LogBook" is marked as private
  Given the LogBook "Test LogBook" is shared with "google_user"
  
  Given I am signed in with "google_oauth2"
  
Scenario: Registered users can see public LogBooks
  Given the number of LogBooks shared with "google_user" is 1
  When I go to the LogBooks index page
  Then I should see the text "Test LogBook"
  And I should see the text "⥮"
  And I should not see the text "✖"
  
Scenario: Registered users can see LogBooks that are shared with them
  Given pending

Scenario: Registered users cannot view a LogBook that is not shared with them
  Given pending
  
Scenario: Registered users cannot change a WorldObject in a LogBook with read-only access
  Given pending

Scenario: Registered users cannot delete a WorldObject in a LogBook with read-only access
  Given pending
  
Scenario: Registered users cannot change a Section in a LogBook with read-only access
  Given pending

Scenario: Registered users cannot delete a Section in a LogBook with read-only access
  Given pending
  
Scenario: Registered users cannot change a LogBook with read-only access
  Given pending

Scenario: Registered users cannot delete a LogBook with read-only access
  Given pending

Scenario: Registered users cannot change the list of users that have access to a LogBook that they do not own
  Given pending
  
Scenario: Registered users lose access to shared LogBooks when the owner takes that access away
  Given pending

Scenario: Registered users CAN change permissions on LogBooks that they own
  Given pending

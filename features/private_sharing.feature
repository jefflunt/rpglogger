Feature: Public sharing

Background:
  Given I am signed in with "facebook"
  And a LogBook exists called "Test LogBook" for game "Skyrim" and owned by "fooman"
  And a Section exists called "Test Section" in "Test LogBook"
  And a WorldObject exists called "Test WorldObject" in "Test Section"
    And the LogBook "Test LogBook" is marked as private
  Then I sign out

Scenario: Registered users can see public LogBooks
  Given pending
  
Scenario: Registered users can see LogBooks that are shared with them
  Given pending

Scenario: Registered users cannot view a LogBook that is not shared with them
  Given pending
  
Scenario: Registered users can neither change nor delete a WorldObject in a LogBook with read-only access
  Given pending
  
Scenario: Registered users can neither change nor delete a Section in a LogBook with read-only access
  Given pending
  
Scenario: Registered users can neither change nor delete a LogBook with read-only access
  Given pending

Scenario: Registered users can neither change the permissions of a LogBook that they do not own
  Given pending

Scenario: Registered users CAN change permissions on LogBooks that they own
  Given pending

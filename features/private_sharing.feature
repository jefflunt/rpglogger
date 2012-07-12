Feature: Private sharing with an editor role

Background:
  Given I am signed in with provider "google_oauth2"
  Given a LogBook exists called "Shared LogBook" for game "Skyrim" and owned by "facebook_user"
  Given a Section exists called "Shared Section" in "Shared LogBook"
  Given a WorldObject exists called "Shared WorldObject" in "Shared Section"
  Given the LogBook "Shared LogBook" is marked as private
  Given the LogBook "Shared LogBook" is shared with "google_user" with the "editor" role
  
Scenario: Editor role users can see LogBooks that are shared with them
  Given the number of LogBooks shared with "google_user" with the "editor" role is 1
  When I go to the LogBooks index page
  Then I should see the text "Shared LogBook"
  And I should see the text "⥮"
  And I should not see the text "✖"  

Scenario: Editor role users do not see the LogBook editing link on the LogBook show page
  Given I go to the show LogBook page for "Shared LogBook"
  Then I should not see the text " | edit"

Scenario: Editor role users can see the edit and delete controls for WorldObjects on LogBooks that are shared with them
  When I go to the show LogBook page for "Shared LogBook"
  Then show me the page
  Then I should see a "a" tag around the text "Shared WorldObject"
  And I should see the text "✖"
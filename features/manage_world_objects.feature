Feature: Manage WorldObjects

Scenario: A user can access WorldObjects that they own
  Given I am signed in with provider "facebook"
  And a LogBook exists called "Test LogBook" for game "Skyrim" and owned by "facebook_user"
  And a Section exists called "Test Section" in "Test LogBook"
  And a WorldObject exists called "Test WorldObject" in "Test Section"
  
  When I access the Section "Test Section"
  Then I should see the text "Test WorldObject"
  
Scenario: A user can edit WorldObjectProperties on WorldObjects that they own
  Given I am signed in with provider "facebook"
  And a LogBook exists called "Test LogBook" for game "Skyrim" and owned by "facebook_user"
  And a Section exists called "Test Section" in "Test LogBook"
  And a WorldObject exists called "Test WorldObject" in "Test Section"
  
  When I edit the WorldObject "Test WorldObject" in "Test Section"
  Then I should see all of the texts:
    | in Test Section |
    | Name            |

Scenario: Access denied message appears for trying to edit WorldObjectProperties on a WorldObjects you do not own
  Given I am signed in with provider "facebook"
  And a LogBook exists called "Someone else's LogBook" for game "Skyrim" and owned by "someoneelse"
  And a Section exists called "Someone else's Section" in "Someone else's LogBook"
  And a WorldObject exists called "Someone else's WorldObject" in "Someone else's Section"
  
  When I edit the WorldObject "Someone else's WorldObject" in "Someone else's Section"
  Then I should see the text "You don't have access to that."
  
Scenario: A user can create new WorldObjects
  Given I am signed in with provider "facebook"
  And a LogBook exists called "Test LogBook" for game "Skyrim" and owned by "facebook_user"
  And a Section exists called "Test Section" in "Test LogBook"
  
  When I go to the new WorldObject page of section "Test Section"
  And I fill in "world_object[name]" with "The new WorldObject"
  And I press "Save"
  Then I should see all of the texts:
    | Test Section        |
    | The new WorldObject |
    | ✚                   |
    | Name/Title          |

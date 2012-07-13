Feature: Trashing and untrashing of data elements in a LogBook

Background:
  Given I am signed in with provider "facebook"

  Given a LogBook exists called "Test LogBook" for game "Skyrim" and owned by "facebook_user"
  Given a Section exists called "Test Section" in "Test LogBook"
  Given a WorldObject exists called "Test WorldObject" in "Test Section"

Scenario: When I trash a LogBook, the `deleted_at` attribute is set
  When I go to the LogBooks index page
  And I follow "✖"
  Then the LogBook "Test LogBook" should be marked as deleted
  And I should see the text "Log book deleted (undo)"
  
  When I follow "undo"
  Then the LogBook "Test LogBook" should NOT be marked as deleted
  And I should see the text "Log book restored"

Scenario: When I trash a Section, the `deleted_at` attribute is set
  When I go to the show LogBook page for "Test LogBook"
  And I follow "edit"
  And I follow "Delete"
  Then the Section "Test Section" in "Test LogBook" should be marked as deleted
  And I should see the text "Section deleted (undo)"
  
  When I follow "undo"
  Then the Section "Test Section" in "Test LogBook" should NOT be marked as deleted
  And I should see the text "Section restored"

Scenario: When I trash a WorldObject, the `deleted_at` attribute is set
  When I go to the show LogBook page for "Test LogBook"
  And I follow "Test Section"
  And I follow "✖"
  Then the WorldObject "Test WorldObject" in "Test Section" in "Test LogBook" should be marked as deleted
  And I should see the text "Deleted (undo)"
  
  When I follow "undo"
  Then the WorldObject "Test WorldObject" in "Test Section" in "Test LogBook" should NOT be marked as deleted
  And I should see the text "Restored"

Scenario: I should be able to see trashed items with a control in the UI, and then restore them
  When I go to the LogBooks index page
  And I follow "✖"
  Then I should not see the text "Test LogBook"
  And the LogBook "Test LogBook" should be marked as deleted
  
  When I follow "Show deleted"
  Then I should see the text "Test LogBook"
  
  When I follow "⟲"
  And I follow "Hide deleted"
  Then I should see the text "Test LogBook"
  And the LogBook "Test LogBook" should NOT be marked as deleted
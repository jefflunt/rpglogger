Feature: Archiving and restoring of data elements in a Logbook

Background:
  Given I am signed in with provider "facebook"

  Given a LogBook exists called "Test LogBook" for game "Skyrim" and owned by "facebook_user"
  Given a Section exists called "Test Section" in "Test LogBook"
  Given a WorldObject exists called "Test WorldObject" in "Test Section"

Scenario: When I archive a LogBook, the `archived_at` attribute is set
  When I go to the LogBooks index page
  And I follow "✖"
  Then the LogBook "Test LogBook" should be marked as archived
  And I should see the text "Logbook archived (undo)"
  
  When I follow "undo"
  Then the LogBook "Test LogBook" should NOT be marked as archived
  And I should see the text "Logbook restored"

Scenario: When I archive a Section, the `archived_at` attribute is set
  When I go to the show LogBook page for "Test LogBook"
  And I follow "Edit"
  And I follow "Archive"
  Then the Section "Test Section" in "Test LogBook" should be marked as archived
  And I should see the text "Section archived (undo)"
  
  When I follow "undo"
  Then the Section "Test Section" in "Test LogBook" should NOT be marked as archived
  And I should see the text "Section restored"

Scenario: When I archive a WorldObject, the `archived_at` attribute is set
  When I go to the show LogBook page for "Test LogBook"
  And I follow "Test Section"
  And I follow "✖"
  Then the WorldObject "Test WorldObject" in "Test Section" in "Test LogBook" should be marked as archived
  And I should see the text "Archived (undo)"
  
  When I follow "undo"
  Then the WorldObject "Test WorldObject" in "Test Section" in "Test LogBook" should NOT be marked as archived
  And I should see the text "Restored"

Scenario: I should be able to see archived LogBooks with a control in the UI, and then restore them
  When I go to the LogBooks index page
  And I follow "✖"
  Then I should not see the text "Test LogBook"
  And the LogBook "Test LogBook" should be marked as archived
  
  When I follow "Show archived"
  Then I should see the text "Test LogBook"
  
  When I follow "⟲"
  And I follow "Hide archived"
  Then I should see the text "Test LogBook"
  And the LogBook "Test LogBook" should NOT be marked as archived

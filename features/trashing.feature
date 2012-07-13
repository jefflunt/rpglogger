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

Scenario: When I untrash a LogBook, the `deleted_at` attribute is cleared to nil
  Given pending

Scenario: When I trash a Section, the `deleted_at` attribute is set
  When I go to the show LogBook page for "Test LogBook"
  And I follow "edit"
  And I follow "Delete"
  Then the Section "Test Section" in "Test LogBook" should be marked as deleted

Scenario: When I untrash a Section, the `deleted_at` attribute is cleared to nil
  Given pending

Scenario: When I trash a WorldObject, the `deleted_at` attribute is set
  When I go to the show LogBook page for "Test LogBook"
  And I follow "Test Section"
  And I follow "✖"
  Then the WorldObject "Test WorldObject" in "Test Section" in "Test LogBook" should be marked as deleted
  

Scenario: When I untrash a WorldObject, the `deleted_at` attribute is cleared to nil
  Given pending
